# gnome-argos-CPU-Nvidea-power-monitor
Scripts for the Argos extension that monitor CPU, GPU (NVIDIA) power consumption, with a custom icon theme
# Monitor de Energia (Wattímetro) para Argos no GNOME

Este projeto contém um conjunto de scripts para a extensão [Argos](https://extensions.gnome.org/extension/1176/argos/) que permitem monitorizar o consumo de energia do CPU, da GPU dedicada (NVIDIA) e do sistema (em portáteis). Inclui também um tema de ícones personalizado para uma melhor integração visual.

![Captura de Ecrã dos Indicadores](https://i.imgur.com/your-screenshot-url.png)
*(Recomendo que tire uma captura de ecrã dos seus indicadores a funcionar e substitua o link acima)*

## Funcionalidades

-   **Monitor de CPU:** Mostra o consumo de energia do CPU em Watts, lendo diretamente os sensores RAPL.
-   **Monitor de GPU (NVIDIA Optimus):** Mostra "Inativa" quando a GPU está a dormir para poupar energia, e mostra o consumo em Watts apenas quando está ativa. Este método evita que a própria monitorização acorde a GPU.
-   **Tema de Ícones Personalizado:** Inclui ícones SVG para o CPU e GPU para uma aparência limpa.

## Dependências

Para que tudo funcione, precisa de ter o seguinte instalado:

-   A extensão [Argos](https://extensions.gnome.org/extension/1176/argos/)
-   `bc` (calculadora de linha de comando): `sudo dnf install bc`
-   Drivers da NVIDIA com `nvidia-smi`
-   `gnome-tweaks` (para ativar o tema de ícones): `sudo dnf install gnome-tweaks`

## Instalação

1.  **Copiar os Scripts**
    ```bash
    # Copia os scripts para a pasta de configuração do Argos
    cp -r scripts/*.sh ~/.config/argos/

    # Torna os scripts executáveis
    chmod +x ~/.config/argos/*.sh
    ```

2.  **Instalar o Tema de Ícones**
    ```bash
    # Copia a pasta do tema para o diretório local de ícones
    cp -r custom-icon-theme/WattimetroIcons ~/.local/share/icons/

    # Atualiza o cache de ícones do sistema (passo importante!)
    gtk-update-icon-cache -f -t ~/.local/share/icons/WattimetroIcons
    ```

3.  **Ativar o Tema de Ícones**
    - Abra a aplicação "Ajustes" (`gnome-tweaks`).
    - Vá ao separador "Aparência".
    - Na secção "Ícones", selecione "WattimetroIcons" na lista.

4.  **Configurar Permissões para o CPU (Avançado)**
    O script do CPU precisa de permissões de administrador para ler o sensor de energia. Execute `sudo visudo` e adicione a seguinte linha no final do ficheiro (substitua `o-seu-username` pelo seu nome de utilizador real):
    ```
    o-seu-username ALL=(ALL) NOPASSWD: /usr/bin/cat /sys/class/powercap/intel-rapl\:0/energy_uj
    ```
    Lembre-se também de alterar a linha `current_energy=$(sudo ...)` no script `cpu-power.5s.sh`.

## Agradecimentos

Este projeto foi desenvolvido com a ajuda da IA Gemini da Google, através de um longo processo de depuração e colaboração.
