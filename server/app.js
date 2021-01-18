
var express             = require('express');
var app                 = express();
var bodyParse           = require('body-parser')

// const Web3jService = require('../api/web3j/web3jService').Web3jService

// var web3 = new Web3jService()
app.use(bodyParse.json())
app.use(bodyParse.urlencoded({extended:false})) ;

const path = require('path');

const fs = require('fs');
var iconv = require('iconv-lite')

var dataPath = './data'
var dirs = []
function getDir(){
    dirs = []
    fs.readdir(dataPath, function(err, files){
        (function iterator(i){
          if(i == files.length) {
            dirs.shift()
            console.log(dirs);
            return ;
          }
          fs.stat(path.join(dataPath, files[i]), function(err, data){     
            if(data.isFile()){               
                dirs.push(files[i]);
            }
            iterator(i+1);
           });   
        })(0);
    });
}
getDir()

app.all('*', function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "X-Requested-With");
    res.header("Access-Control-Allow-Methods","PUT,POST,GET,DELETE,OPTIONS");
    res.header("X-Powered-By",' 3.2.1')
    res.header("Content-Type", "application/json;charset=utf-8");
    next();
})

function readContent(path){
    var fileStr=fs.readFileSync('./data/'+path,{encoding:'binary'});
    return fileStr
}

// 处理根目录的get请求
app.get('/test',function(req,res){
    var fileStr=fs.readFileSync('./data/lxx 123456.txt',{encoding:'binary'});
    
    // fileStr = JSON.parse(fileStr)
    console.log(fileStr)
    res.send(fileStr)
})
app.get('/',function(req,res){
    res.send('这里是根目录') ;
    console.log('main page is required ');
}) ;

// 处理/login的get请求
app.post('/add', function (req,res) {
    console.info(req.body.name,'  sss  ')
}) ;

// 处理/login的post请求
app.post('/login',function(req,res){
    let data = req.body
    let temp2 = {}
    for(let item in data){
        temp2 = item
        console.info(item)
    }
    temp2 = JSON.parse(temp2)
    console.info(temp2)
    name=temp2.name ;
    pwd=temp2.pwd   ;
    // name = req.body.name
    // pwd = req.body.pwd
    var flag = false
    console.log(name+'--'+pwd) ;
    // res.status(200).send(name+'--'+pwd);
    var pro = new Promise((resolve, reject) =>{
        for(var i = 0; i < dirs.length; ++ i) {
            var temp = dirs[i].substring(0, dirs[i].length-4)
            var r = temp.split(' ')

            if(r[0] == name.toString() && r[1] == pwd.toString()){
                flag = true
                var promise = new Promise((resolve, reject) =>{
                    var data = readContent(dirs[i])
                    resolve(data)
                })
                // res.send('登陆成功',readContent(dirs[i]))
                // flag = true
                promise.then(function(data){
                    
                    res.status(200).send(data)
                    
                })
            }
        }
        resolve(flag)
    })
    
    pro.then(function(flag){
        if(flag == false){
            res.send('failed')
        }
    })

});

// 处理注册的post请求
app.post('/register',function(req,res){
    let data = req.body
    let temp2 = {}
    for(let item in data){
        temp2 = item
        console.info(item)
    }
    temp2 = JSON.parse(temp2)
    console.info(temp2)
    name=temp2.name ;
    pwd=temp2.pwd   ;
    // name = req.body.name
    // pwd = req.body.pwd
    var flag = true
    console.log(name+'--'+pwd) ;
    console.info('sss',  dirs)
    for(var i = 0; i < dirs.length; ++ i) {
        var temp = dirs[i].substring(0, dirs[i].length-4)
        var r = temp.split(' ')
        if(r[0] == name) {
            flag = false
            res.send('failed')
            break
        }
    }
    if(flag) {
        var filename = './data/'+name+' '+pwd+'.txt'
        fs.writeFile(filename,'',function(error){
            if(error){
                console.info(error)
                res.send('failed')
                return false
            }
            res.send('success')
        })
    }
    getDir()
});

app.post('/addActivity',function(req,res){
    let data = req.body
    let temp2 = {}
    for(let item in data){
        temp2 = item
    }
    temp2 = JSON.parse(temp2)
    // temp = req.body
    temp = temp2
    name =  temp.name
    pwd = temp.pwd
    date = temp.date
    console.info('date  ',date)
    activity = temp.activity

    filename = './data/'+name+' '+pwd+'.txt'

    var fileData = ''

    fs.readFile(filename,'utf-8',function(error, fileData){
    	var judge = false;
        if(error){
            console.info(error)
            res.send('failed')
            return false
        }
        var r = fileData.split(/[\s\n]/)
        for(var i = 0; i < r.length; i++)
        {
        	var rt = r[i].split(':')
        	if(rt[0] == date)
        	{
        		rt[1] = rt[1] + ',' + activity
        		judge = true
        	}
        	r[i] = rt.join(':')
        }
        if(judge == false)
        {
        	var newData = date + ':' + activity;
        	r.push(newData)
        	judge = true
        }
        r.sort(function(a, b){
        	var aDate = a.split(':')[0]
        	var bDate = b.split(':')[0]
        	return aDate - bDate
        })
        fileData = r.join('\n')
        console.info(fileData)
        res.send('success')

        fs.writeFile(filename, fileData, (error) => {
    		if (error) throw error;
		});
    });

    
})

app.post('/delActivity',function(req,res){
    let data = req.body
    let temp2 = {}
    for(let item in data){
        temp2 = item
    }
    temp2 = JSON.parse(temp2)
    // temp = req.body
    temp = temp2
    name =  temp.name
    pwd = temp.pwd
    date = temp.date
    activity = temp.activity

    filename = './data/'+name+' '+pwd+'.txt'

    var fileData = ''

    fs.readFile(filename,'utf-8',function(error, fileData){
        if(error){
            console.info(error)
            res.send('failed')
            return false
        }
        var r = fileData.split(/[\s\n]/)
        for(var i = 0; i < r.length; i++)
        {
        	var rt = r[i].split(':')
        	if(rt[0] == date)
        	{
        		var rtActivity = rt[1].split(',')
        		console.info(rtActivity)
        		for(var j = 0; j < rtActivity.length; j++)
        		{
        			if(rtActivity[j] == activity)
        			{
        				rtActivity.splice(j,1)
        				break;
        			}
        		}
        		if(rtActivity.length == 0)
        		{
        			r.splice(i,1)
        			break;
        		}
        		rt[1] = rtActivity.join(',')
        	}
        	r[i] = rt.join(':')
        }
        r.sort(function(a, b){
        	var aDate = a.split(':')[0]
        	var bDate = b.split(':')[0]
        	return aDate - bDate
        })
        fileData = r.join('\n')
        console.info(fileData)
        res.send('success')

        fs.writeFile(filename, fileData, (error) => {
    		if (error) throw error;
		});
    });

    
})


// 监听3000端口
console.info('listen 3000')
var server=app.listen(3000) ;