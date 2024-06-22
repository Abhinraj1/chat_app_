const User = require('../models/auth');
const jwt = require('jsonwebtoken');

const Auth = async(req,res,next)=>{

   try{
    const token = req.header("x-auth-token");
    console.log(token);zx   
    if(!token){
        return res.status(400).json({msg:"No valid token!"});
    }

    const verify = jwt.verify(token,"SECRETKEY");
    if(!verify){
        return res.status(400).json({msg:"Token verification failed!"});
    }

    req.id = verify.id;
    req.token = token;
    next();
   }
   catch(e){
    return res.status(500).json({error:err.message});
   }
}

module.exports = Auth;