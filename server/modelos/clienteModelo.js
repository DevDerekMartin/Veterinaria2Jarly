const {DataTypes} = require('sequelize');
const mysqlSequelize = require('../database/conexionDb');

const clienteModelo = mysqlSequelize.define(
    'cliente',
    {
        id:{
            type: DataTypes.INTEGER,
            primaryKey: true,
            autoIncrement: true,
        },
        DNI:{
            type: DataTypes.CHAR(10),
            allowNull: false
        },
        nombres: {
            type: DataTypes.STRING(100),
            allowNull: false    
        },
        email:{
            type: DataTypes.STRING(100),
            allowNull: false
        },
        contacto:{
            type: DataTypes.CHAR(10),
            allowNull: false
        },
        fecha_nacimiento:{
            type: DataTypes.DATE,
            allowNull: false
        },
        genero:{
            type: DataTypes.ENUM('M', 'F', 'O'),
            allowNull: false
        },
        direccion:{
            type: DataTypes.STRING(100),
            allowNull: false
        },
        ciudad:{
            type: DataTypes.STRING(100),
            allowNull: false
        },
        referencia:{
            type: DataTypes.STRING(100),
            allowNull: false
        }
    },
    {
        tableName: 'cliente',
        timestamps: false
    }
);

module.exports = clienteModelo;
