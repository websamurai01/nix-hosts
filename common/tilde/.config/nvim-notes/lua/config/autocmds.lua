local augroup = vim.api.nvim_create_augroup("Notes", { clear = true })

-- Function to handle Metadata (Created/Modified footers)
-- Called manually via Keymaps (<leader>s, ZZ)
_G.UpdateMetadata = function()
  -- Safety: Do not run on special buffers (like file explorers)
  if vim.bo.buftype ~= "" then return end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local created_idx = nil
  local modified_idx = nil

  -- Time format: YYYY-MM-DD at HH:MM UTC+XXXX (e.g. UTC+0200)
  local time_str = os.date("%Y-%m-%d at %H:%M UTC%z")

  -- Scan for existing metadata lines
  for i, line in ipairs(lines) do
    if line:match("^created:%s+") then
      created_idx = i
    elseif line:match("^modified:%s+") then
      modified_idx = i
    end
  end

  local changed = false

  -- 1. Update 'modified' if it exists
  if modified_idx then
    lines[modified_idx] = "modified:  " .. time_str
    changed = true
  end

  -- 2. Prepare lines to append if missing
  local to_append = {}

  if not created_idx then
    table.insert(to_append, "created:   " .. time_str)
  end

  if not modified_idx then
    table.insert(to_append, "modified:  " .. time_str)
  end

  -- 3. Append missing metadata to the bottom
  if #to_append > 0 then
    -- Add a blank spacer line if the file has content and doesn't end with one
    local last_line = lines[#lines]
    if #lines > 0 and last_line ~= "" and not last_line:match("^created:") and not last_line:match("^modified:") then
      table.insert(lines, "")
    end
    
    for _, l in ipairs(to_append) do
      table.insert(lines, l)
    end
    changed = true
  end

  -- Apply changes if any
  if changed then
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  end
end

_G.Rename = function()
  -- 1. Find the first line with text
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local line
  for _, l in ipairs(lines) do
    if l:match("%S") then
      line = l
      break
    end
  end

  -- If empty, we cannot generate a name based on content. Return.
  if not line then return end

  -- 2. Determine Timestamp
  -- Always generate new Timestamp (UTC) to represent time of save/rename
  local timestamp = os.date("!%Y%m%d-%H%M%S")

  -- 3. Sanitize Content
  -- Replace illegal filesystem symbols with underscore.
  local text = line:gsub('[<>:"/\\|%?%*]', "_")
  
  -- Collapse multiple spaces into one
  text = text:gsub("%s+", " ")
  
  -- Trim leading/trailing whitespace
  text = text:match("^%s*(.-)%s*$")

  -- 4. Truncate (Max 45 chars)
  if #text > 45 then
    -- vim.fn.strcharpart is safer for UTF-8 than string.sub
    text = vim.fn.strcharpart(text, 0, 45)
    text = text:match("^(.-)%s*$")
  end

  -- Fallback if sanitization left nothing
  if #text == 0 then text = "untitled" end

  -- 5. Construct Filename
  local filename = timestamp .. " " .. text .. ".txt"

  -- 6. Determine Target Directory
  local buf_name = vim.api.nvim_buf_get_name(0)
  local target_dir

  if buf_name == "" then
    -- Case A: New buffer (No Name) -> Use Default Notes Directory
    target_dir = vim.fn.expand("~/Documents/Notes")
  else
    -- Case B: Existing file -> Use that file's directory
    -- :p:h gets the full path head (directory) of the file
    target_dir = vim.fn.fnamemodify(buf_name, ":p:h")
  end
  
  local new_path = target_dir .. "/" .. filename
  local current_path = vim.fn.expand("%:p")

  -- 7. Rename Logic (Move File)
  if current_path ~= new_path then
    -- 'saveas!' writes the file to the new name immediately
    vim.cmd("saveas! " .. vim.fn.fnameescape(new_path))
    
    -- Delete the old file if it existed
    if current_path ~= "" and vim.fn.filereadable(current_path) == 1 then
      vim.fn.delete(current_path)
    end
    
    -- Set the new file as the current buffer name explicitly
    vim.cmd("file " .. vim.fn.fnameescape(new_path))
    vim.api.nvim_echo({{ "Renamed: " .. filename, "Comment" }}, false, {})
  end
end

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto-resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Create directories when saving files (Generic helper)
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  callback = function(event)
    if event.match:match("^%w+://") then return end
    local dir = vim.fn.expand('<afile>:p:h')
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
    end
  end,
})

-- -- Auto-enter Insert Mode when opening
-- vim.api.nvim_create_autocmd("VimEnter", {
--   group = augroup,
--   callback = function()
--     -- Defer slightly to ensure UI/ZenMode is settled
--     vim.defer_fn(function()
--       if vim.bo.modifiable then
--         vim.cmd("startinsert")
--       end
--     end, 10)
--   end,
-- })
