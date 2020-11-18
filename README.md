# MatePerformance
Este repositorio contiene herramientas que permiten evaluar el rendimiento de [RTruffleMATE], una máquina virtual reflexiva que implementa el modelo propuesto por MATE.

El repositorio esta organizado de la siguiente manera:

* El directorio [Data](Data) contiene archivos comprimidos con los resultados luego de la ejecución de los diferentes benchmarks.
* El directorio [PReport](PReport) contiene diferentes scripts para procesar los resultados y representarlos en forma de tablas y gráficos compatibles con Latex.
* El directorio [Containers](Containers) contiene un Dockerfile con la configuración para construir un container con las herramientas necesarias para ejecutar los experimentos.
* El directorio  [Scripts](Scripts) contiene diferentes utilitarios utilizado para ejecutar los experimentos dentro del container.
* El directorio  [Conf](Conf) contiene las definiciones de los experimentos para ejecutar mediante el framework rebench.

Instrucciones para ejecutar los experimentos
--------------------------------------------

Clonar el repositorio:

    git clone https://github.com/gefarion/MatePerformance.git directoryName
    cd directoryName

Para construir el container Docker ejecutar:

    cd Containers
    make build

Luego para correr un experimento ejecutar:
    ./Setup/runExperiments.sh EXPERIMENTO

Experimentos disponibles:
- "AreWeFast"
- "Inherent"
- "IndividualActivations"
- "Readonly"
- "ReadonlyAwf"
- "Tracing"
- "ReflectiveCompilation"
- "Baseline"