const express = require('express');
const mysqlSequelize = require('../database/conexionDb')

const ruta = express.Router();

// Obtener registros
ruta.get(
    '/obtener-servicios',
    async (req, res) => {
        try{
            const registrosServicios = await mysqlSequelize.query('CALL OBTENER_SERVICIOS()');
            res.status(200).json(registrosServicios);
        }catch(error){
            res.status(500).json({message: `Registros no encontrados ${error.message}`});
        }
    }
);

// Insertar registros
ruta.post(
    '/insertar-servicio',
    async (req, res) =>{
        try{
            const {
                CODIGO,
                NOMBRE,
                FECHA_REGISTRO,
                DESCRIPCION,
                ESTADO,
                PRECIO
            } = req.body;
            await mysqlSequelize.query(
                'CALL INSERTAR_SERVICIO(:CODIGO, :NOMBRE, :FECHA_REGISTRO, :DESCRIPCION, :ESTADO, :PRECIO)',
                {
                    replacements:{
                        CODIGO,    
                        NOMBRE,
                        FECHA_REGISTRO,
                        DESCRIPCION,
                        ESTADO,
                        PRECIO
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
    '/actualizar-servicio',
    async (req, res) =>{
        try{
            const {
                CODIGO,
                NOMBRE,
                FECHA_REGISTRO,
                DESCRIPCION,
                ESTADO,
                PRECIO
            } = req.body;
            await mysqlSequelize.query(
                'CALL ACTUALIZAR_SERVICIO(:CODIGO, :NOMBRE, :FECHA_REGISTRO, :DESCRIPCION, :ESTADO, :PRECIO)',
                {
                    replacements:{
                        CODIGO,
                        NOMBRE,
                        FECHA_REGISTRO,
                        DESCRIPCION,
                        ESTADO,
                        PRECIO
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
