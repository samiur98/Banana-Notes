const express = require('express')

const crypto = require('crypto')
const crypto_algorithm = 'aes-256-ctr'
const crypto_password = '5gToFe456HeIo'

const router = express.Router()
const body_parser = require('body-parser')
router.use(body_parser.urlencoded({extended: false}))

const mysql = require('mysql')

const pool = mysql.createPool({
    connectionLimit: 150, //One less than the maximum allowed by MySQL.
    host: 'localhost',
    user: 'root',
    password: 'boyzRback2514',
    database: 'banana_notes',
})

router.get("/getUser/:email/:password", (req, res) => {
    //Process GET request for getting an existing user.
    console.log("Processing GET request for getting a user from the users database")
    if(!validateFields(req)){
        console.log("Missing/Incorrectly formatted email and/or password.")
        res.sendStatus(400)
        return
    }
    const email = req.params.email
    const password = req.params.password
    const sqlQuery = `SELECT * FROM users WHERE email = '${email}';`
    pool.query(sqlQuery, (err, rows, fields) => {
        if(err){
            console.log("Error in connecting to database while processing GET request.")
            res.sendStatus(500)
            return
        }
        if(rows.length <= 0){
            console.log("User with provided email does not exist in the database.")
            res.sendStatus(404)
            return
        }
        if(password != decrypt(rows[0].password)){
            console.log(`Wrong password, failed to authenticate user:${email}.`)
            res.sendStatus(403)
            return
        }
        console.log(`Successfully retrieved and authenticated user:${email} during GET request.`)
        res.send({userId:rows[0].id, userEmail:email})
    })
})

router.post('/addUser/:email/:password', (req, res) => {
    //Proccess POST request for adding a new user.
    console.log("Processing POST request for adding a new user.")
    if(!validateFields(req)){
        console.log("Missing/Incorrectly formated email and/or password.")
        res.sendStatus(400)
        return
    }
    const email = req.params.email
    const password = req.params.password
    const encrypted_password = encrypt(password)
    const sqlQuery = `INSERT INTO users (email, password) values ('${email}', '${encrypted_password}');`
    pool.query(sqlQuery, (err, row, fields) => {
        if(err){
            console.log("Error in connecting to user database while executing POST request.")
            res.sendStatus(500)
            return
        }
        console.log(`POST request successfully processed, new user:${email} added.`)
        res.sendStatus(201)
    })
    

})

function encrypt(password){
    //Encryption algorithm for passwords.
    //Uses the node crypto library and AES256 algorithm.
    var cipher = crypto.createCipher(crypto_algorithm, crypto_password)
    var crypt = cipher.update(password, 'utf8', 'hex')
    crypt += cipher.final('hex')
    return crypt
}

function decrypt(password){
    //Decryption algorithm for passwords.
    //Uses the node crypto library and AES256 algorithm.
    var decipher = crypto.createDecipher(crypto_algorithm, crypto_password)
    var decrypt = decipher.update(password, 'hex', 'utf8')
    decrypt += decipher.final('utf8')
    return decrypt
}

function validateFields(req){
    //Validates email and password in Get request in the case of missing/wrongly formatted request.
    //Returns true if there are no errors, false otherwise.
    if((typeof req.params.email != 'string') || (typeof req.params.password != 'string')){
        console.log("Email and/or password is not of type string.")
        return false
    }
    if(req.params.password.length < 8){
        console.log("Password does not have the minimum requirememnt of 8 characters")
        return false
    }
    return true
}

module.exports = router