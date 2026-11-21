import path from 'path';
import os from 'os';
import fs from 'fs';
import process from 'process';
import { fileURLToPath } from 'url';

// --- CONFIGURATION ---

const completelyIgnore = [
    // General Noise
    '**/*.log', '**/*.lock', '**/node_modules/**',
    '**/.git/**', '**/dist/**', '**/coverage/**',
    '**/tmp/**', '**/.cache/**', '**/.DS_Store',
    '**/*.rmlock', '**/.direnv/**',

    // Specific Binary/Asset exclusions
    '**/*.png', '**/*.jpg', '**/*.jpeg', '**/*.gif', 
    '**/*.ico', '**/*.woff', '**/*.woff2', '**/*.ttf',
    '**/*.svg', '**/*.pdf',

    // Runtime Databases & State
    '**/mpd/database',
    '**/mpd/sticker.sql',
    
    // Auto-generated Lock files
    '**/lazy-lock.json'
];

// Files to keep in tree, but strip content
// (Currently empty as we moved extensions to completelyIgnore, 
// but kept here if you want to see specific files exist without content)
const stripExts = [
];

// --- PATH LOGIC ---

const args = process.argv.slice(2);
const targetArg = args.find(arg => !arg.startsWith('-'));
const cwd = process.cwd();
const absolutePath = targetArg ? path.resolve(cwd, targetArg) : cwd;

// Determine the location of THIS config file to find .txt files alongside it
const __filename = fileURLToPath(import.meta.url);
const configDir = path.dirname(__filename);

const homeDir = os.homedir();
let prettyPath = absolutePath;
if (prettyPath.startsWith(homeDir)) {
    prettyPath = prettyPath.replace(homeDir, '~');
}

// --- OUTPUT NAMING ---

const dynamicName = prettyPath
    .replace(/^\//, '')
    .replace(/[\/\s]+/g, '-') + '.xml';

const outputDir = path.join(homeDir, 'LLM/repomix');
const fullOutputPath = path.join(outputDir, dynamicName);

if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
}

// --- POST-PROCESSING HOOK ---

process.on('exit', () => {
    try {
        if (!fs.existsSync(fullOutputPath)) return;

        let content = fs.readFileSync(fullOutputPath, 'utf8');

        // 1. Ingest External .txt files as Tags
        // Example: "explanation.txt" -> <explanation>content</explanation>
        let injectedTags = '';
        try {
            const files = fs.readdirSync(configDir);
            const txtFiles = files.filter(file => file.endsWith('.txt'));

            for (const file of txtFiles) {
                // Get name without extension (e.g., "explanation")
                // Replace spaces/dashes with underscores to make valid XML-like tags
                const rawName = path.parse(file).name;
                const tagName = rawName.replace(/[^a-zA-Z0-9_]/g, '_');
                
                const filePath = path.join(configDir, file);
                const fileContent = fs.readFileSync(filePath, 'utf8').trim();
                
                if (fileContent) {
                    injectedTags += `<${tagName}>\n${fileContent}\n</${tagName}>\n\n`;
                }
            }
        } catch (e) {
            console.warn('Warning: Could not read external .txt files:', e.message);
        }

        // 2. Merge Path into Directory Structure
        // We find the opening tag and inject the Root path immediately after
        const openTag = '<directory_structure>';
        const injectedRoot = `${openTag}\nRoot: ${prettyPath}\n`;
        
        if (content.includes(openTag)) {
            content = content.replace(openTag, injectedRoot);
        }

        // 3. Prepend Injected Tags
        // We simply place the custom text files at the very top
        content = injectedTags + content;

        // 4. Strip Binary/Image Content
        const escDots = stripExts.map(e => e.replace('.', '\\.'));
        if (escDots.length > 0) {
            const extPattern = escDots.join('|');
            
            // Regex: <file path="...ext"> content </file>
            const startTag = `<file path="[^"]+(?:${extPattern})">`;
            const wildcard = '[\\s\\S]*?'; 
            const endTag = '<\\/file>\\s*'; 
    
            const regex = new RegExp(startTag + wildcard + endTag, 'gi');
            
            content = content.replace(regex, '');
        }

        fs.writeFileSync(fullOutputPath, content);
        console.log(`\n✅ Processed: ${dynamicName}`);

    } catch (err) {
        console.error('Error post-processing:', err);
    }
});

// --- EXPORT ---

export default {
    output: {
        filePath: fullOutputPath,
        style: 'xml',
        fileSummary: false,
        removeEmptyLines: false,
        removeComments: false, 
    },
    ignore: {
        customPatterns: completelyIgnore,
        useGitignore: true,
        useDefaultPatterns: true,
    },
};
