#!/bin/bash

# путь к лог файлу
LOG_FILE="$(pwd)/system_report.log"
SCRIPT_PATH="$(realpath "$0")"

# установка cron
if [[ "$1" == "--setup" ]]; then
    echo "Настройка автоматического запуска..."
# вспомогательные команды:) (crontab -l) выводит текущие задачи, (echo) добавляет новую, (| crontab -) сохраняет всё обратно
    (crontab -l 2>/dev/null; echo "0 * * * * $SCRIPT_PATH") | crontab -
    echo "Готово!"
    exit 0
fi

echo "--- отчёт о состоянии системы ($(date)) ---" | tee -a $LOG_FILE

# 1 Проверим диски
echo "[DISK USAGE]" >> $LOG_FILE
df -h | grep '^/dev/' >> $LOG_FILE

# 2 Проверим оперативку
echo -e "\n[MEMORY USAGE]" >> $LOG_FILE
free -m >> $LOG_FILE
# 3 И выведим топ 5 процессов по потреблению цпу(CPU)
echo -e "\n[TOP 5 PROCESSES]" >> $LOG_FILE
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6 >> $LOG_FILE

echo -e "\n--- отчёт сохранен в $LOG_FILE ---\n"
