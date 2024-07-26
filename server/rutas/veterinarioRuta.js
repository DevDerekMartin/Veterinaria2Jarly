const express = require('express');
const mysqlSequelize = require('../database/conexionDb')

const ruta = express.Router();

// Obtener registros
ruta.get(
    '/obtener-veterinarios',
    async (req, res) => {
        try{
            const registrosVeterinarios = await mysqlSequelize.query('call obtener_veterinarios()');
            res.status(200).json(registrosVeterinarios);
        }catch(error){
            res.status(500).json({message: `Registros no encontrados ${error.message}`});
        }
    }
);

// Insertar registros
ruta.post(
    '/insertar-veterinario',
    async (req, res) =>{
        try{
            const {
                DNI,
                NOMBRES,
                EMAIL,
                CONTACTO,
                FECHA_NACIMIENTO,
                GENERO,
                ESPECIALIDAD,
                DIRECCION,
                CIUDAD,
                REFERENCIA
            } = req.body;
            await mysqlSequelize.query(
                'CALL INSERTAR_VETERINARIO(:DNI, :NOMBRES, :EMAIL, :CONTACTO, :FECHA_NACIMIENTO, :GENERO, :ESPECIALIDAD, :DIRECCION, :CIUDAD, :REFERENCIA)',
                {
                    replacements:{
                        DNI,
                        NOMBRES,
                        EMAIL,
                        CONTACTO,
                        FECHA_NACIMIENTO,
                        GENERO,
                        ESPECIALIDAD,
                        DIRECCION,
                        CIUDAD,
                        REFERENCIA
                    }
                }
            );
            res.status(200).json({Message: `Insercción valida`});
        }catch(error){
            res.status(500).json({message: `Insercción invalida ${error.message}`});
        }
    }
);

// Insertar registros
ruta.post(
    '/actualizar-veterinario',
    async (req, res) =>{
        try{
            const {
                DNI,
                NOMBRES,
                EMAIL,
                CONTACTO,
                FECHA_NACIMIENTO,
                GENERO,
                ESPECIALIDAD,
                DIRECCION,
                CIUDAD,
                REFERENCIA
            } = req.body;
            await mysqlSequelize.query(
                'CALL ACTUALIZAR_VETERINARIO(:DNI, :NOMBRES, :EMAIL, :CONTACTO, :FECHA_NACIMIENTO, :GENERO, :ESPECIALIDAD, :DIRECCION, :CIUDAD, :REFERENCIA)',
                {
                    replacements:{
                        DNI,
                        NOMBRES,
                        EMAIL,
                        CONTACTO,
                        FECHA_NACIMIENTO,
                        GENERO,
                        ESPECIALIDAD,
                        DIRECCION,
                        CIUDAD,
                        REFERENCIA
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
