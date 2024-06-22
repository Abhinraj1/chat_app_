const express = require('express');
const mongoose = require('mongoose');
const jwt = require('jsonwebtoken');
const bjs = require('bcryptjs');
const User = require('../models/auth');
const Auth = require('../middlewares/auth');
const authRouter = express.Router();



authRouter.post('/api/auth/signUp',async(req,res)=>{

    try{
        const{name,email,password} = req.body;
        const existUser = await User.findOne({email});
        if(existUser){
            return res.status(400).json({msg:"User with this email already exist!"});
        }
    console.log(email);
        const hashedPassword = await bjs.hash(password,8);
        let user = new User({
            name,
            email,
            password:hashedPassword,
        });
    
        user = await user.save();
        res.json(user);
    }
    catch(e){
        
        res.status(500).json({error:e.message});
    }
});

authRouter.post('/api/auth/signIn',async(req,res)=>{

    try{
        const{email,password} = req.body;
        const validUser = await User.findOne({email});
        if(!validUser){
            return res.status(400).json({msg:"User with this email not exist!"});
        }
    
        const validPass = await bjs.compare(password,validUser.password);
        if(!validPass){
            return res.status(400).json({msg:"Password is incorrect!"});
        }
    
        const token = await jwt.sign({id:validUser._id},"SECRETKEY");
        res.json({...validUser._doc,token});
    }
    catch(e){
        res.status(500).json({error:e.message}); 
    }
});

authRouter.get('/api/isValidToken',async(req,res)=>{
    try{
        const token = req.header("x-auth-token");
        if(!token){
            return res.json(false);
        }
        const verify = jwt.verify(token,"SECRETKEY");
        if(!verify){
            return res.json(false);
        }
        const user = await User.findById(verify.id);
        if(!user){
            return res.json(false);
        }
    
        res.json(true);
    }
    catch(e){
        res.status(500).json({error:e.message});
    }
    
});

authRouter.get('/api/getUserData',Auth,async(req,res)=>{
    const token = req.header("x-auth-token");
    console.log(token);
    const user = await User.findById(req.id);
    console.log(user);
    res.json({...user._doc,token});
});




authRouter.post('/api/updateProfilPic',async(req,res) => {
   try{
    const {profilePic,id} = req.body;
    let user = await User.findById(id);
    user.profilePic = profilePic;
    user = await user.save();
    res.json({"profilePic":user.profilePic})
   }
   catch(e){
res.status(500).json({error:e.message});
   }
})
module.exports = authRouter;

