const express = require('express');
const mysqlSequelize = require('../database/conexionDb')

const ruta = express.Router();

// Obtener registros
ruta.get(
    '/obtener-proveedores',
    async (req, res) => {
        try{
            const registrosProveedores = await mysqlSequelize.query('CALL OBTENER_PROVEEDORES()');
            res.status(200).json(registrosProveedores);
        }catch(error){
            res.status(500).json({message: `Registros no encontrados ${error.message}`});
        }
    }
);

// Insertar registros
ruta.post(
    '/insertar-proveedor',
    async (req, res) =>{
        try{
            const {
                RUC,
                NOMBRE,
                EMAIL,
                CONTACTO,
                FECHA_REGISTRO,
                DESCRIPCION,
                DIRECCION,
                PAIS,
                CIUDAD,
            } = req.body;
            await mysqlSequelize.query(
                'CALL INSERTAR_PROVEEDOR(:RUC, :NOMBRE, :EMAIL, :CONTACTO,:FECHA_REGISTRO, :DESCRIPCION, :DIRECCION, :PAIS, :CIUDAD)',
                {
                    replacements:{
                        RUC,
                        NOMBRE,
                        EMAIL,
                        CONTACTO,
                        FECHA_REGISTRO,
                        DESCRIPCION,
                        DIRECCION,
                        PAIS,
                        CIUDAD
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
    '/actualizar-proveedor',
    async (req, res) =>{
        try{
            const {
                RUC,
                NOMBRE,
                EMAIL,
                CONTACTO,
                DESCRIPCION,
                DIRECCION,
                PAIS,
                CIUDAD,
            } = req.body;
            await mysqlSequelize.query(
                'CALL ACTUALIZAR_PROVEEDOR(:RUC, :NOMBRE, :EMAIL, :CONTACTO, :DESCRIPCION, :DIRECCION, :PAIS, :CIUDAD)',
                {
                    replacements:{
                        RUC,
                        NOMBRE,
                        EMAIL,
                        CONTACTO,
                        DESCRIPCION,
                        DIRECCION,
                        PAIS,
                        CIUDAD,
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
