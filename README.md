"# RISC_V" 
# 💻 Processeur Multicycle en VHDL

Ce projet implémente un processeur multicycle basé sur une architecture MIPS simplifiée, conçu en VHDL. Il simule le fonctionnement d’un processeur capable d’exécuter des instructions de type R, I et de mémoire, en utilisant des modules séparés interconnectés.

##  Structure du projet

Le projet est composé des fichiers suivants :

| Fichier VHDL       | Description du module                      |
|--------------------|--------------------------------------------|
| `pc.vhdl`          | Compteur de programme                      |
| `adder_pc.vhdl`    | Incrémentation de PC                       |
| `alu.vhdl`         | Unité arithmétique et logique              |
| `alu_control.vhdl` | Génération des signaux de l'ALU            |
| `register_file.vhdl` | Registre général pour les instructions   |
| `sign_extend.vhdl` | Extension de signe des instructions        |
| `instr_data_mem.vhdl` | Mémoire commune instruction/donnée      |
| `datapath.vhdl`    | Chemin de données du processeur            |
| `control.vhdl`     | Unité de contrôle principale               |
| `top.vhdl`         | Intégration de tous les modules            |
| `top_tb.vhdl`      | Banc de test complet pour simulation       |

## ⚙️ Simulation

La simulation a été réalisée avec **ModelSim** et **GHDL**.

### Compilation avec ModelSim

Dans ModelSim, les fichiers ont été compilés dans cet ordre :

```tcl
vcom pc.vhdl
vcom adder_pc.vhdl
vcom alu.vhdl
vcom alu_control.vhdl
vcom register_file.vhdl
vcom sign_extend.vhdl
vcom instr_data_mem.vhdl
vcom datapath.vhdl
vcom control.vhdl
vcom top.vhdl
vcom top_tb.vhdl
vsim work.top_tb
run 500 ns

