#!/bin/bash
#736259, Garcia, Hector, T, 2, B
#778053, Hernando, Marcos, T, 2, B 

#Practica-5

if [ $# -ne 1 ]
then
    echo "Numero incorrecto de parametros"
    echo "Sintaxis correcta: ./practica_parte2.sh Direccion_IP"
    exit 2
fi

#ruta="/home/hector/.ssh/id_as_ed25519"
ruta="~/.ssh/id_as_ed25519"

ssh -n -i "$ruta" as@$1 "sudo sfdisk -s"    #Lista los discos duros disponibles y sus tamaños
ssh -n -i "$ruta" as@$1 "sudo sfdisk -l"    #Lista las particiones y sus tamaños
ssh -n -i "$ruta" as@$1 "sudo df -hT"       #Lista la información de montaje de sistemas de ficheros
