#!/bin/bash

# --- Script para ler o consumo do CPU diretamente do /sys ---

# Caminho para o ficheiro do sensor de energia do CPU (em microJoules)
energy_file="/sys/class/powercap/intel-rapl:0/energy_uj"

# Caminho para um ficheiro temporário onde guardamos a última leitura
tmp_file="/tmp/cpu_power_last_reading.txt"

# --- Verificações Iniciais ---
# Verificar se o ficheiro do sensor realmente existe
if [ ! -f "$energy_file" ]; then
  echo "CPU: Sensor N/A | iconName=wattimetro-cpu-symbolic"
  exit
fi

# Ler a energia (em microJoules) e o tempo (em segundos com nanosegundos) atuais
current_energy=$(sudo /usr/bin/cat "$energy_file")
current_time=$(date +%s.%N)

# Se o ficheiro temporário com a leitura antiga já existe...
if [ -f "$tmp_file" ]; then
  # ...lê os valores antigos do ficheiro.
  last_reading=$(cat "$tmp_file")
  last_time=$(echo "$last_reading" | cut -d' ' -f1)
  last_energy=$(echo "$last_reading" | cut -d' ' -f2)

  # Calcula a diferença de tempo e de energia usando a calculadora 'bc'
  time_delta=$(echo "$current_time - $last_time" | bc)
  energy_delta=$(echo "$current_energy - $last_energy" | bc)

  # Evita divisão por zero se o tempo for demasiado curto ou negativo
  is_delta_positive=$(echo "$time_delta > 0" | bc -l)
  if [ "$is_delta_positive" -eq 1 ]; then
    # Converte a energia de microJoules para Joules (divide por 1,000,000)
    # Potência (Watts) = Joules / segundos
    power=$(echo "scale=2; $energy_delta / 1000000 / $time_delta" | bc)
    echo "CPU: ${power}W | iconName=wattimetro-cpu-symbolic"
  fi
fi

# No fim, guarda sempre a leitura atual no ficheiro temporário para a próxima execução do script
echo "$current_time $current_energy" > "$tmp_file"
