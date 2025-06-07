#!/bin/bash

# Script Argos Final (v5) com Correção de Locale

GPU_PCI_ADDRESS="0000:01:00.0"
STATUS_FILE="/sys/bus/pci/devices/${GPU_PCI_ADDRESS}/power/runtime_status"

if [ ! -f "$STATUS_FILE" ]; then
  echo "GPU: Sensor N/A | iconName=wattimetro-gpu-symbolic"
  exit
fi

gpu_status=$(cat "$STATUS_FILE")

if [ "$gpu_status" == "suspended" ]; then
  # Adicionámos o iconName=power-sleep-symbolic aqui
  echo "GPU: Inativa | iconName=wattimetro-gpu-symbolic"
  echo "---"
  echo "A GPU dedicada está a poupar energia."

elif [ "$gpu_status" == "active" ]; then
  sleep 0.5
  if command -v nvidia-smi &> /dev/null; then
    power_draw=$(nvidia-smi --query-gpu=power.draw --format=csv,noheader,nounits)
    if [[ $power_draw =~ ^[0-9]+([.][0-9]+)?$ ]]; then
      # Adicionámos o iconName=display-symbolic aqui
      power_draw_formatted=$(LC_NUMERIC=C printf "%.1f" "$power_draw")
      echo "GPU: ${power_draw_formatted}W | iconName=wattimetro-gpu-symbolic"
      echo "---"
      echo "Consumo atual da GPU."
    else
      echo "GPU: Ativa (a ler...) | iconName=gpu-symbolic"
      echo "---"
      echo "A GPU está ativa, a inicializar a leitura."
    fi
  else
    echo "GPU: Ativa (sem smi) | iconName=wattimetro-gpu-symbolic"
  fi
else
  echo "GPU: Estado '$gpu_status' | iconName=wattimetro-gpu-symbolic"
fi
