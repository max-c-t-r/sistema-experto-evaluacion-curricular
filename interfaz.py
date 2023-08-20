import tkinter as tk
from tkinter import messagebox
from pyswip import Prolog


prolog = Prolog()
def obtener_respuestas():
    respuestas = []
    for rubro in ["rubro1", "rubro2", "rubro3", "rubro4", "rubro5", "rubro6", "rubro7"]:
        for pregunta in prolog.query(f"preguntas_rubro({rubro}, Preguntas)."):
            pregunta_str = pregunta["Preguntas"][0]
            respuesta = input(pregunta_str)
            respuestas.append((rubro, respuesta))
    
    print(respuestas)
    return respuestas

def cargar_respuestas_en_prolog(respuestas):
    for rubro, respuesta in respuestas:
        prolog.assertz(f"respuesta_usuario('{rubro}', '{respuesta}')")  # Quita el punto final

def calcular_puntaje():
    prolog.consult("preguntas.pl")  # Reemplaza con la ruta al archivo Prolog
    
    respuestas = obtener_respuestas()
    cargar_respuestas_en_prolog(respuestas)
    
    puntaje = list(prolog.query("calcular_puntaje_total(Puntaje)."))[0]["Puntaje"]
    messagebox.showinfo("Puntaje Total", f"Tu puntaje total es: {puntaje}")

# Crear la interfaz
root = tk.Tk()
root.title("Calculadora de Puntaje")

btn_calcular = tk.Button(root, text="Calcular Puntaje", command=calcular_puntaje)
btn_calcular.pack(padx=20, pady=10)

root.mainloop()
