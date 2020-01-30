
HT Condor cluster configuration using Lammps (https://lammps.sandia.gov/) with MPI

# Instalación y Configuración del Cluster

En esta sesión, se presentan los comandos usados y la descripción detallada de los pasos necesarios para la instalación y configuración del cluster.

## Configuración de direccionamientos, nombres y red

Primero, es necesario instalar las utilidades VIM y WGET:

  
![](https://docs.google.com/drawings/u/0/d/sm1Kp87qrIiABcxfYxBstzw/image?w=686&h=31&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)

Para configurar el hostname de la máquina se debe ejecutar el siguiente comando (debe cambiar `cad01-w00` por el nombre de su preferencia):

 **![](https://docs.google.com/drawings/u/0/d/sGOZroE2CTHtsa5AhTlCTEQ/image?w=686&h=31&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)**

  

Agregue las entradas de los nombres de los diferentes workers al archivo “/etc/hosts”. El archivo deberá lucir de la siguiente forma:

 

    172.16.0.105 cad01-head01.company.edu.co cad01-head01
    172.16.0.101 cad01-submit01.company.edu.co cad01-submit01
    172.16.0.109 cad01-nfs01.company.edu.co cad01-nfs01
    172.16.0.108 cad01-w000.company.edu.co cad01-w000
    172.16.0.111 cad01-w001.company.edu.co cad01-w001
    172.16.0.100 cad01-w002.company.edu.co cad01-w002
    172.16.0.104 cad01-w003.company.edu.co cad01-w003
    172.16.0.112 cad01-w004.company.edu.co cad01-w004
    172.16.0.116 cad01-w005.company.edu.co cad01-w005
    172.16.0.114 cad01-w006.company.edu.co cad01-w006


  
  

  

Luego, deberá detener y deshabilitar el firewall del sistema operativo usando los siguientes comandos:

  
![](https://docs.google.com/drawings/u/0/d/sL8InTjGnCTLb--lLdWEPYw/image?w=686&h=47&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)  

Instale y configure el servicio Network Time Protocol (NTP):

  
![](https://docs.google.com/drawings/u/0/d/sRJogJYcE6DlhWgjYx-K1xQ/image?w=686&h=96&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)  
  
  

Instale el servidor NFS:

  
![](https://docs.google.com/drawings/u/0/d/s7HXu28WfEyMNZf12N9XO_g/image?w=686&h=32&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)  

Configure el dominio `company.edu.co` en el archivo de configuración `/idmapd.conf`:

    Domain = company.edu.co  

Cree los directorios `condor` y `data` dentro de `/exports`

  
![](https://docs.google.com/drawings/u/0/d/sd0Mjbz82Ix0xALevyXdMYg/image?w=686&h=49&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)  

Agregue las siguientes entradas al archive `/etc/exports`

  
![](https://docs.google.com/drawings/u/0/d/sSf94TRFE2HGZ8JsLyXaXvA/image?w=686&h=49&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)  

Inicie y habilite el servicio `nfs-server`

  
![](https://docs.google.com/drawings/u/0/d/shH5Naux6aMH2oWjuMmgvTg/image?w=686&h=49&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)  

Instale “NFS Client”

  
![](https://docs.google.com/drawings/u/0/d/sXYZjP-57uPJfaJHA6XVCYQ/image?w=686&h=31&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)  

Configure el dominio `company.edu.co` en el archivo `/etc/idmapd.conf`:

 

     Domain = company.edu.co

Cree los directorios `condor` y `data` dentro de `/nfs`

  
![](https://docs.google.com/drawings/u/0/d/sNSEVH4zqdXYQdtoihFjyUA/image?w=686&h=50&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)  

Inicie y habilite el servicio `rpcbind`

  
![](https://docs.google.com/drawings/u/0/d/s-X-4qJ1invIunjiQVn7whg/image?w=686&h=50&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)  

Monte los directorios `condor` y `data`

    sudo mount -t nfs cad01-nfs.company.edu.co:/exports/condor /nfs/condor
    sudo mount -t nfs cad01-nfs.company.edu.co:/exports/condor /nfs/data


Agregue las respectivas entradas al archivo `/etc/fstab`

    cad01-nfs.company.edu.co:/exports/condor /nfs/condor nfs defaults 0 0
    cad01-nfs.company.edu.co:/exports/data /nfs/condor nfs defaults 0 0

  
  

Instale `autofs`

  
![](https://docs.google.com/drawings/u/0/d/s87AJ1ANve3i9_SrIfxV7QA/image?w=686&h=31&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)  

Agregue la siguiente entrada al archivo `/etc/auto.master`

  
![](https://docs.google.com/drawings/u/0/d/sBfqU7YEleTDgJxfhocU8xA/image?w=686&h=31&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)  

Agregue las siguientes entradas al archivo `/etc/auto.mount`

    /nfs/condor -fstype=nfs,rw cad01-nfs.company.edu.co:/exports/condor /nfs/condor
    /nfs/data -fstype=nfs,rw cad01-nfs.company.edu.co:/exports/condor /nfs/data

  
 

Inicie y habilite el servicio `autofs`

  
![](https://docs.google.com/drawings/u/0/d/sefDlZWGANv5VriUSZK-O3Q/image?w=686&h=47&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)  

## Instalación de HTCondor

Descargue el archivo del repositorio desde el cual se instalará “HTCondor”

  
![](https://docs.google.com/drawings/u/0/d/sz57FjZloEgbS8HJQLJt2DA/image?w=686&h=66&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)  
  

Importe la llave del repositorio anterior, desde el cual se instalará “HTCondor”

  
![](https://docs.google.com/drawings/u/0/d/sHoHM7_kl5AN9G_cDtdZauA/image?w=686&h=45&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)  

Instale “HTCondor”

  
![](https://docs.google.com/drawings/u/0/d/sUtJiSGP9oi2OuUJ5c1dYtA/image?w=686&h=30&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)  

Habilite e inicie el servicio “condor”

  
![](https://docs.google.com/drawings/u/0/d/s0KS7_UODXQ50fLdmilO6cg/image?w=686&h=68&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)

Ejecutar después de la configuración para permitir el acceso a los servicios HTCondor en la red

  
![](https://docs.google.com/drawings/u/0/d/sbSEktzGEOUIr_5IoWeT9bQ/image?w=686&h=30&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)  
  

Los siguientes archivos de configuración deben ser copiados a todos los demás nodos:

    *.cluster
    *.headnode
    *.scheed
    *.worker

  

## Envío do Jobs (HTCondor)

  

Para el envío de Jobs en HTCondor, podemos utilizar el ejemplo 1 ejecutado en el Taller 1.

  

Acceder a la carpeta del ejemplo 1

  
![](https://docs.google.com/drawings/u/0/d/snMxz5KLcNwh-UZ2Ug_Iqbg/image?w=686&h=30&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)  

Ejecutar el envío de Jobs sobre el pool de HTCondor

  
![](https://docs.google.com/drawings/u/0/d/s7lXxeuF1gcavqYYnHCtCTw/image?w=686&h=30&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)  

La salida es:

    Submitting job(s).
    1 job(s) submitted to cluster XXX.

  
Se puede ejecutar el siguiente comando para ver la cola de ejecución de HTCondor.

![](https://docs.google.com/drawings/u/0/d/sGlp6ub7Fr01R3F4d0eTxbA/image?w=686&h=30&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)  

# Aplicaciones

En esta sesión se prestan las aplicaciones seleccionadas para instalación, así como sus comandos para instalación y ejecución.

## MPI

El cluster es capaz de enviar Jobs que usen MPI por medio de HTCondor. Para esto, utilizamos las siguientes herramientas:

-   OpenMPI: implementación de la especificación MPI (OpenMPI, 2004-2016, [https://www.open-mpi.org](https://www.open-mpi.org/))
    
-   LAMMPS: Simulador de Dinámica Molecular (LAMMPS, [https://lammps.sandia.gov/](https://lammps.sandia.gov/)). Software que nos ayudará a ejemplificar la ejecución de un programa en HTCondor con MPI.
    

Ambas aplicaciones serán instaladas en el host NFS, disponibles para todos los workers.

  

### OpenMPI

En la compilación de esta implementación, se ejecutaron los siguientes pasos, en el host NFS:

Primero se extrae el archivo de configuración de OpenMPI

![](https://docs.google.com/drawings/u/0/d/sfjuxVoY4fcczMn_3TC8n1Q/image?w=686&h=30&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)  

Se ingresa dentro de la carpeta que es generada

![](https://docs.google.com/drawings/u/0/d/sF0ZFjbIQ9ysV6KpvZ6p3Lg/image?w=686&h=30&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)  

Se realiza el proceso de configuración, con los siguientes parámetros definidos

![](https://docs.google.com/drawings/u/0/d/sN_pEviAGz3Sb-baGpVwNcA/image?w=686&h=30&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)  

El siguiente paso es compilar el software de instalación
![](https://docs.google.com/drawings/u/0/d/sth8I_997N7PjnnnjJ0UPLg/image?w=686&h=30&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)  

### LAMMPS

LAMMPS es un software para simulación de dinámica molecular clásica. Para su compilación fue necesaria la inclusión de las siguientes librerías:

`-   fftw-3.3.8:` Subrutina de C para la computación de Transformaciones Discretas de Fourier (FFTW, 2018, [http://www.fftw.org/](http://www.fftw.org/)).
    
`-   libjpeg-turbo-master-2.0.0:` Necesaria para la generación de imágenes (libjpeg.turbo, 2018, [https://github.com/libjpeg-turbo/libjpeg-turbo](https://github.com/libjpeg-turbo/libjpeg-turbo)).
    
La aplicación LAMMPS debe ser instalada en el servidor NFS, según los pasos abajo.

Primero, debe dirigirse a la carpeta `/exports/data/tools/` para realizar la instalación

  
![](https://docs.google.com/drawings/u/0/d/sJfMrn8PE15Od1sB2DuPnuQ/image?w=686&h=30&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)  

Se descomprime el paquete de instalación de LAMMPS

![](https://docs.google.com/drawings/u/0/d/soMiElXbm5YuJ3BYi-5oYCw/image?w=686&h=30&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)  

Se ingresa a la carpeta generada

![](https://docs.google.com/drawings/u/0/d/sfFJr9CPxh-yixAhzTk14Pw/image?w=686&h=30&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)  

Compilar el software de instalación 

![](https://docs.google.com/drawings/u/0/d/sV0TD1y6UGtZv7Ymm6azQZQ/image?w=685&h=47&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)

  
  
Los últimos dos comandos, se utilizan para compilar LAMMPS con MPI y sin MPI, se generan los siguientes archivos:

    /exports/data/tools/lammps/src/lmp_mpi
    /exports/data/tools/lammps/src/lmp_g++_serial


### Ejemplo en MPI

rigid: ejemplo en MPI que representa cuerpos rígidos modelados como independientes o acoplados.

Para este ejemplo el archivo “rigid.sub” fue creado con la descripción del trabajo para que sea ejecutado en HTCondor. Su contenido es detallado abajo:

    Universe = parallel
    Executable = openmpiscript
    Arguments = rigid.sh in.rigid
    getenv = true
    Log = rigid.$(Process).$(Node).log
    Output = rigid.$(Process).$(Node).out
    Error = rigid.$(Process).$(Node).error
    Notification = error
    should_transfer_files = YES
    when_to_transfer_output = ON_EXIT
    transfer_input_files = rigid.sh,in.rigid,data.rigid
    machine_count = 4
    Queue

El siguiente comando ejecuta el trabajo sobre el pool de HTCondor:

  
![](https://docs.google.com/drawings/u/0/d/slKzi2jXRftdBO2wh-865IA/image?w=686&h=30&rev=1&ac=1&parent=1-8El6gkPJ1a4OTxdNNGykW-f9WURuU7GM_uqEObU28w)  

El resultado genera una secuencia de 100 imágenes como es presentado abajo:

![](https://lh3.googleusercontent.com/FTxfCNTTCDSSRfmQLIAa7sDYGa85fJjHC7vFaIQJTwTNdsuPp07H0TpHrYlsO71Xw-kBgb-8yWyiUq8eYtqkvVxfu4qmJf8VvWih-rVykKwixXG1Q40aZprITzf_wyk3qagLMIuQGkcMDkoO4Q)![](https://lh3.googleusercontent.com/S6hD3MzmRiZJi6-yMsEjRb2q-Ux_9oiKXHOEU5mZEJfs-Ooj9OLpqRd2r5iFRpvbuyDanRjLqRrTMMpcj_MNTisO7tdLY32gZMcZvBbt6Wot56PlAE8PkxSxi-tTQl73QrLHscL4IGv06vdPpw)![](https://lh3.googleusercontent.com/JvFgiWERqaFj4f-Mdp_7rgsPf2luMJ5brcQPYnYtaE87cQGJ4ae_YO_xeSmlbBjzmqFkgcDVYygN8OTihJbECnqjnVMb_bKkJTHFjrRM6aWu3G_lEkJaZflOLBU-nonNQoKlmqndCeQPhymsvQ)![](https://lh6.googleusercontent.com/p7xGvgR3kD-djo5AVz2PlC0B7HTfiMURNdX81iBYZYWCH4zS4iyaw8mfVJ2jGRFRxqag6cAHuIDQmRZBbPa-F-_czz5_dawdA4vWzG0ZusCEJmG23ZfVTj1BQMyP8gffwgeRosUiwfI-c5VDmg)![](https://lh5.googleusercontent.com/ufUvdrq50jGkiTqWEnrLk-aLtmj0H8NacK3zbaFuKcFUzH7WI1dsvIuSIJBBr6Fl7myV1Fv2HVmTE0IlwDN3LbG_T4d3KD4NAHJxvoLkVQx17Dz8whwZ6cvEflvqV1ajcRzxj-XkRcDcSfxTJw)![](https://lh4.googleusercontent.com/qUtY8q9OFTAys-Bz4cMEJnW8SUkb2fLe7KjStwuK1kxDGPOZIPVmo1T3Y9YasZbvkq2j52Ape76hsPoje_yLYa_xs3CsUHOuNpJ78bObrqKsgOgCRitVeykPpdDL9BzrV-HMS0RSw2bQyGGQCg)![](https://lh3.googleusercontent.com/MB0jCapYwV0iNleh0pwcguKOGgeWo-aKSMvR1tvVW5DO1Ct_07Ie3rsBInoPluCf1Z9cyjVUwnQ3V41ms8DijaZPDMAfqAQ9-BN_aqmyv5uskbYWnYZ6bc_q4a8VqnzY987IJfjwBn6qjnR_rg)![](https://lh5.googleusercontent.com/wT4nRrRklAWY4dAcTyAsjUqpSSnSEUZA3vrlyBQqQJfimEZBjDu-fEpgAhqBynkIE3z3ZGzzU6pToX9ld8mBvjdQtMjnXkJURaYXpQ-MCcG8-YjK2EnLfYTOuq9YbqmSikhgWrjNY9NjSa3iRQ)![](https://lh4.googleusercontent.com/Km6rtqRme8s0s6fj8DuUrixgfT7mvWAQJQPJSmkpTHI989UtMGkwlIKc-lznYy-9eYSoO9Y7tNuZwNSjp_8FbdpX84afselxPWJXt8MoJZ9lJbcLFlonr5k2MHY5UXyPqA-JbUH4JYuZ4aPXZA)![](https://lh6.googleusercontent.com/9CcRVCBtxFDPgf2MB7QdBog2ruRIOigVCl3PwYvLiogoE4Q5HezXgeBof1CqkGGxjYc94g6UOYFnExfMjBBBwRkjcHFqa2fdehTZuW-Xejul9LAqd3ehEpBSJ04-EbPdgAZqrRjtbHkKFv1Y2g)![](https://lh4.googleusercontent.com/cRdQ4SSyKcTlvVIsoliogSZVtQ_w9AV9tYgfQuky_nw1Sn_RNoWSQjAPDeHZkKnAMsqGrYp8gnwsu63RhwCxZruLh3LmclmgRPxeoMFpbRC73dK8KnqndYxaZQCXUvd_FiSZRcmpMn4L91B66A)![](https://lh3.googleusercontent.com/MNWhmLJOD-0FNokvZRvT31s0HWbE3CBTK1oYeUUjdzdKP3QZhxbFLhV4o5428rc26qPqgpz-zLWA6D4c-cT8FkZ9Y1MmgYiWPSeXy5z6PybB5Zv82fiJN4OPpajEKcgrF9xOw3siOgRmX_4DhQ)


