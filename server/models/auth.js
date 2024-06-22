const mongoose = require('mongoose');


const UserModel = mongoose.Schema({

    name:{
        required:true,
        trim:true,
        type:String,
    },
    email:{
        required: true,
        type: String,
        trim:true,
        validate:{
            validator: (value)=>{
                const re =
          /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
        return value.match(re);
            },
            message:"Enter valid email!",
        }
    },
    password:{
        required:true,
        type: String,
    },
    
    
     profilePic:{
        default:"https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1200px-Default_pfp.svg.png",
        type:String,
    },
   

});

const User = mongoose.model('Users',UserModel);
module.exports = User;

