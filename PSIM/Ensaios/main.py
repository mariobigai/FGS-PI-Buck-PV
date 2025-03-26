import subprocess
import pyautogui
import time

# Executando a simulação
# cmd_list = [['psimcmd', '-i', '10_4 Buck - Controle PI e FGS_PI PV 200W.psimsch', '-o', 'ensaio_StepRef.txt'],
#             ['psimcmd', '-i', '14_1 Buck - ensaio 1 config 1 MPPT PI e FGS_PI PV 200W.psimsch', '-o', 'ensaio1_config1.txt'],
#             ['psimcmd', '-i', '14_1 Buck - ensaio 1 config 2 MPPT PI e FGS_PI PV 200W.psimsch', '-o', 'ensaio1_config2.txt'],
#             ['psimcmd', '-i', '14_2 Buck - ensaio 2 config 1 MPPT PI e FGS_PI PV 200W.psimsch', '-o', 'ensaio2_config1.txt'],
#             ['psimcmd', '-i', '14_2 Buck - ensaio 2 config 2 MPPT PI e FGS_PI PV 200W.psimsch', '-o', 'ensaio2_config2.txt'],
#             ['psimcmd', '-i', '14_3 Buck - ensaio 3 config 1 MPPT PI e FGS_PI PV 200W.psimsch', '-o', 'ensaio3_config1.txt'],
#             ['psimcmd', '-i', '14_3 Buck - ensaio 3 config 2 MPPT PI e FGS_PI PV 200W.psimsch', '-o', 'ensaio3_config2.txt']]

cmd_list = [['psimcmd', '-i', '14_3 Buck - ensaio 3 config 2 MPPT PI e FGS_PI PV 200W.psimsch', '-o', 'ensaio3_config2.txt']]

for cmd in cmd_list:
    subprocess.Popen(cmd)  # Usando Popen para não bloquear o código

    # Espera a caixa de diálogo aparecer
    time.sleep(3)

    # Pressiona Enter para fechar a caixa de diálogo
    pyautogui.press('enter')


