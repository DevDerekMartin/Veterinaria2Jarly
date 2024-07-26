const express = require('express');
const mysqlSequelize = require('../database/conexionDb')

const ruta = express.Router();

// Obtener registros
ruta.get(
    '/obtener-mascotas',
    async (req, res) => {
        try{
            const registrosMascotas = await mysqlSequelize.query('CALL OBTENER_MASCOTAS()');
            res.status(200).json(registrosMascotas);
        }catch(error){
            res.status(500).json({message: `Registros no encontrados ${error.message}`});
        }
    }
);

// Insertar registros
ruta.post(
    '/insertar-mascota',
    async (req, res) =>{
        try{
            const {
                DNI,
                CODIGO,
                NOMBRE,
                FECHA_REGISTRO,
                TIPO,
                RAZA,
                PESO,
                ALTURA,
                EDAD,
                SEXO,
                OBSERVACIONES,
                SERVICIO
            } = req.body;
            await mysqlSequelize.query(
                'CALL INSERTAR_MASCOTA(:CODIGO, :DNI, :NOMBRE, :FECHA_REGISTRO, :TIPO, :RAZA, :PESO, :ALTURA, :EDAD, :SEXO, :OBSERVACIONES, :SERVICIO)',
                {
                    replacements:{
                        DNI,
                        CODIGO,
                        NOMBRE,
                        FECHA_REGISTRO,
                        TIPO,
                        RAZA,
                        PESO,
                        ALTURA,
                        EDAD,
                        SEXO,
                        OBSERVACIONES,
                        SERVICIO
                    }
                }
            );
            res.status(200).json({Message: `Insercción valida`});
        }catch(error){
            res.status(500).json({message: `Insercción invalida ${error.message}`});
        }
    }
);

module.exports = ruta;

// Insertar registros
ruta.post(
    '/actualizar-mascota',
    async (req, res) =>{
        try{
            const {
                DNI,
                CODIGO,
                NOMBRE,
                FECHA_REGISTRO,
                TIPO,
                RAZA,
                PESO,
                ALTURA,
                EDAD,
                SEXO,
                OBSERVACIONES,
                SERVICIO
            } = req.body;
            await mysqlSequelize.query(
                'CALL ACTUALIZAR_MASCOTA(:CODIGO, :DNI, :NOMBRE, :FECHA_REGISTRO, :TIPO, :RAZA, :PESO, :ALTURA, :EDAD, :SEXO, :OBSERVACIONES, :SERVICIO)',
                {
                    replacements:{
                        DNI,
                        CODIGO,
                        NOMBRE,
                        FECHA_REGISTRO,
                        TIPO,
                        RAZA,
                        PESO,
                        ALTURA,
                        EDAD,
                        SEXO,
                        OBSERVACIONES,
                        SERVICIO
                    }
                }
            );
            res.status(200).json({Message: `Insercción valida`});
        }catch(error){
            res.status(500).json({message: `Insercción invalida ${error.message}`});
        }
    }
);

module.exports = ruta;
