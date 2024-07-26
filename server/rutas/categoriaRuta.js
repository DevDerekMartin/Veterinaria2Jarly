const express = require('express');
const mysqlSequelize = require('../database/conexionDb')

const ruta = express.Router();

// Obtener registros
ruta.get(
    '/obtener-categorias',
    async (req, res) => {
        try{
            const registrosCategorias = await mysqlSequelize.query('CALL OBTENER_CATEGORIAS()');
            res.status(200).json(registrosCategorias);
        }catch(error){
            res.status(500).json({message: `Registros no encontrados ${error.message}`});
        }
    }
);

// Insertar registros
ruta.post(
    '/insertar-categoria',
    async (req, res) =>{
        try{
            const {
                CODIGO,
                NOMBRE,
                FECHA_REGISTRO,
                DESCRIPCION,
                ESTADO
            } = req.body;
            await mysqlSequelize.query(
                'CALL INSERTAR_CATEGORIA(:CODIGO, :NOMBRE, :FECHA_REGISTRO, :DESCRIPCION, :ESTADO)',
                {
                    replacements:{
                        CODIGO,
                        NOMBRE,
                        FECHA_REGISTRO,
                        DESCRIPCION,
                        ESTADO
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
    '/actualizar-categoria',
    async (req, res) =>{
        try{
            const {
                CODIGO,
                NOMBRE,
                FECHA_REGISTRO,
                DESCRIPCION,
                ESTADO
            } = req.body;
            await mysqlSequelize.query(
                'CALL ACTUALIZAR_CATEGORIA(:CODIGO, :NOMBRE, :FECHA_REGISTRO, :DESCRIPCION, :ESTADO)',
                {
                    replacements:{
                        CODIGO,
                        NOMBRE,
                        FECHA_REGISTRO,
                        DESCRIPCION,
                         ESTADO
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
