#!/bin/bash
#736259, Garcia, Hector, T, 2, B
#778053, Hernando, Marcos, T, 2, B

#Practica-5 Parte III : extienda la capacidad de un grupo volumen añadiéndole particiones.

if [ $# -lt 2 ] #Comprobamos que el número de parametros sea el correcto
then
    echo "Numero invalido de parametros"
    exit 2
fi

v_group=$1
shift # -> Desplaza los argumentos hacia la izquierda $3 -> $2 $2 -> $1 ... , en este caso descarta $1

if ! sudo vgdisplay "$v_group" >/dev/null 2>&1 #Como siempre redireccionamos la salida a "basura"
                                             #vgdisplay: si actua sobre un grupo de volumenes -> muestra sus atributos
                                             #           si actua sin parámetro -> muestra todos los grupos de volumenes
                                             #                          logicos,fisicos y tamaños
then
    echo "El volumen $v_group no existe"
    exit 2
fi

for i in "$@"   #para trabajar sobre los parametros
do
    if [ ! -b "$i" ] >/dev/null 2>&1  #Al igual que comprobabamos si existia un file -f. -b para bloques especiales
    then
	echo "No existe la particion $i"
	exit 2
    else
        if mount | grep "$i" >/dev/null 2>&1 #Comprobamos si ya esta montada esta particion
        then
            echo "La particion $i ya esta montada"
        else
            if (sudo pvdisplay "$i" | grep "$v_group") >/dev/null 2>&1 #Comprobamos que ya este añadida al volumen logico
            then
                echo "Particion ya ha sido añadida"
            else
                echo y | sudo pvcreate "$i" >/dev/null 2>&1            #Con esto creamos el volumen fisico para 
                sudo vgextend "$v_group" "$i" >/dev/null 2>&1  #posteriormente añadirlo al grupo volumen                        
                echo "El volumen fisico $i ha sido añadido"
            fi
        fi
    fi
done


