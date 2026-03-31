{ pkgs, username, ... }:

let
  librechat-toggle = pkgs.writeShellApplication {
    name = "librechat-toggle";
    runtimeInputs = with pkgs; [ docker-compose libnotify podman ];
    text = ''
      export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
      cd "/home/${username}/l/LibreChat"

      # Проверяем, запущен ли контейнер LibreChat
      if [ "$(docker-compose ps --quiet LibreChat)" ] && [ "$(docker inspect -f '{{.State.Running}}' "$(docker-compose ps -q LibreChat)")" == "true" ]; then
          notify-send "LibreChat" "Выключение сервисов..." -i chatgpt
          docker-compose stop
          notify-send "LibreChat" "Сервисы остановлены" -i chatgpt
      else
          notify-send "LibreChat" "Запуск сервисов..." -i chatgpt
          docker-compose up -d
          notify-send "LibreChat" "Запущено на http://localhost:3080" -i chatgpt
      fi
    '';
  };
in
{
  environment.systemPackages = [ librechat-toggle ];
}
