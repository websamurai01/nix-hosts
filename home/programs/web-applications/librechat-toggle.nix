{ pkgs, username, ... }:

let
  librechat-script = pkgs.writeShellApplication {
    name = "librechat-toggle";
    runtimeInputs = with pkgs; [ docker-compose libnotify podman coreutils procps ];
    text = ''
      # Лог для отладки
      exec 2>"/tmp/librechat.log"
      set -x

      export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
      
      # ТВОЙ ТОЧНЫЙ ПУТЬ (с учетом регистра)
      CHAT_DIR="/home/${username}/librechat/Librechat"

      if [ ! -d "$CHAT_DIR" ]; then
          # На всякий случай проверяем вариант с большой буквой в конце
          if [ -d "/home/${username}/librechat/LibreChat" ]; then
              CHAT_DIR="/home/${username}/librechat/LibreChat"
          else
              notify-send "LibreChat" "Ошибка: Папка $CHAT_DIR не найдена" -u critical
              exit 1
          fi
      fi

      cd "$CHAT_DIR"

      # Проверка статуса (работает ли контейнер)
      if docker-compose ps --format json | grep -q "running"; then
          notify-send "LibreChat" "Выключение сервисов..."
          docker-compose stop
          notify-send "LibreChat" "Сервисы остановлены"
      else
          notify-send "LibreChat" "Запуск нейросетей..."
          if docker-compose up -d; then
              notify-send "LibreChat" "Запущено: http://localhost:3080"
          else
              notify-send "LibreChat" "Ошибка запуска! См. /tmp/librechat.log" -u critical
          fi
      fi
    '';
  };

  librechat-desktop = pkgs.makeDesktopItem {
    name = "librechat-toggle";
    desktopName = "LibreChat AI";
    exec = "librechat-toggle";
    icon = "chatgpt";
    categories = [ "Network" "Utility" ];
    terminal = false;
  };
in
{
  environment.systemPackages = [ 
    librechat-script
    librechat-desktop
  ];
}
