// Destructuración que el módulo sequelize exporta una clase
const {Sequelize} = require('sequelize');

const mysqlSequelize = new Sequelize(
    'veterinaria2', 
    'root', 
    '1234', 
    {
        host: 'localhost',
        dialect: 'mysql'
    }
);

module.exports = mysqlSequelize;