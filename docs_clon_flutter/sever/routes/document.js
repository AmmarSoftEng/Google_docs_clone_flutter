
const express=require('express');
//const { model } = require('mongoose');
const auth = require('../middewares/auth');
const Document = require('../models/document');
const documentRoute=express.Router();

// documentRoute.post("/doc/create", auth, async(req,res)=>{

//     try{
//         const { createdAt }=req.body;
//         let document= new Document({
//             uid: req.user,
//             title: "Untitle Document",
//             createdAt,

//         });
//         document= await document.save();
//         res.json(document);
//     }catch (e){
//         res.status(500).json({error:e.message});
//     }


// });

documentRoute.post("/doc/create", auth, async (req, res) => {
    try {
      const { createdAt } = req.body;
      let document = new Document({
        uid: req.user,
        title: "Untitled Document",
        createdAt,
      });
  
     document = await document.save();
      res.json(document);
    } catch (e) {
      res.status(501).json({ error: e.message });
    }
  });


documentRoute.get("/docs/me", auth, async (req,res)=>{

  try{

    let documents=await Document.find({uid:req.user});
    res.json(documents);
  }catch (e){
 res.status(501).json({ error: e.message });
  }
});

documentRoute.post("/doc/title", auth, async (req, res) => {
  try {
    const { id,title } = req.body;
    let document = await Document.findByIdAndUpdate(id,{title});
    res.json(document);
  } catch (e) {
    res.status(501).json({ error: e.message });
  }
});


documentRoute.get("/doc/:id", auth, async (req,res)=>{

  try{

    let documents=await Document.findById(req.params.id);
    res.json(documents);
  }catch (e){
 res.status(501).json({ error: e.message });
  }
});

module.exports=documentRoute;