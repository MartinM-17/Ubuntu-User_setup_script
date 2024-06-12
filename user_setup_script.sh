#!/bin/bash

# Función para registrar eventos en syslog
log_event() {
    local message="$1"
    logger -t user_setup_script "$message"
}

# Crear grupos
groupadd Desarrollo
log_event "Grupo Desarrollo creado."
groupadd Operaciones
log_event "Grupo Operaciones creado."
groupadd Ingenieria
log_event "Grupo Ingenieria creado."

# Crear usuarios y asignar a grupos
users=("dev_user1" "dev_user2" "ops_user1" "ops_user2" "eng_user1" "eng_user2")
groups=("Desarrollo" "Desarrollo" "Operaciones" "Operaciones" "Ingenieria" "Ingenieria")
password="f=Y>7-$ioF"

for i in "${!users[@]}"; do
    user="${users[$i]}"
    group="${groups[$i]}"
    useradd -m -G "$group" -s /bin/bash "$user"
    echo "$user:$password" | chpasswd
    log_event "Usuario $user creado y asignado al grupo $group."
done

# Crear carpetas específicas y asignar ownership
for user in "${users[@]}"; do
    mkdir -p "/home/$user"
    chown "$user:$user" "/home/$user"
    chmod 700 "/home/$user"
    log_event "Carpeta /home/$user creada y ownership asignado a $user:$user."
done

log_event "Configuración de usuarios y grupos completada."
echo "Script ejecutado y configuraciones realizadas. Revisa el syslog para más detalles."

