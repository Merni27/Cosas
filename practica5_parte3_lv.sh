#!/bin/bash
#736259, Garcia, Hector, T, 2, B
#778053, Hernando, Marcos, T, 2, B

#Practica-5 Parte III a partir de una especificación
#obtenida por entrada estándar, pueda crear o extender los volúmenes lógicos
#y sistemas de ficheros que residan en dichos volúmenes

nombreGV=$(echo "$1" | cut -d',' -f1)       #Cortamos de la ristra los campos necesarios usando la coma como delimitador
nombreVL=$(echo "$1" | cut -d',' -f2)
tamano=$(echo "$1" | cut -d',' -f3)
tipoSistFich=$(echo "$1" | cut -d',' -f4)
dirMont=$(echo "$1" | cut -d',' -f5)

if ! sudo vgdisplay "$nombreGV" >/dev/null 2>&1 #Comprobamos si no existe nombreGV
then
    echo "El grupo volumen $nombreGV no existe"
    exit 2
fi

if ! sudo lvdisplay | grep /dev/"$nombreGV"/"$nombreVL" >/dev/null 2>&1 #Comprobamos que no existe nombreVL para crearlo
then 
    echo "Creación de volumen logico $nombreVL"
    sudo lvcreate -L "$tamano" --name "$nombreVL" "$nombreGV"
    sudo mkfs."$tipoSistFich" /dev/"$nombreGV"/"$nombreVL"
    sudo mkdir "$dirMont"
    sudo mount -t "$tipoSistFich" /dev/"$nombreGV"/"$nombreVL" "$dirMont"
    echo "/dev/$nombreGV/$nombreVL $dirMont $tipoSistFich defaults 0 2" | sudo tee -a /etc/fstab >/dev/null 2>&1 #Modificamos fichero fstab
    echo "Completado, volumen logico $nombreVL creado"
else
    sudo lvextend -L "+$tamano" /dev/"$nombreGV"/"$nombreVL" #Sintaxis con +TamañoLogico a extender
    sudo resize2fs /dev/"$nombreGV"/"$nombreVL" #Se extiende
fi
