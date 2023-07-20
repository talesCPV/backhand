/* GLOBAL DATA */ 

    var mainData = new Object
    const maps = []


/* FUNCTIONS */

function checkLogin(){
    let out = false
    if(localStorage.getItem('idUser') == null){
        document.querySelector('#log-inout').style.display = 'block'
        document.querySelector('#log-inout').innerHTML = 'login'
        document.querySelector('#usr').innerHTML = ''
//        hideMenu()
        openScreen()
    }else{
        document.querySelector('#log-inout').innerHTML = 'logout'
        document.querySelector('#log-inout').style.display = 'none'
        document.querySelector('#usr').innerHTML = localStorage.getItem('atleta')
//        hideMenu(false)
        openScreen(false)
        out = true
        showUserPic()
    }
    
    return out
}

function showUserPic(){
    const back = backFunc({'filename':`../assets/users/${localStorage.getItem('idUser')}.jpg`},1)
    back.then((resp)=>{
        const imgExist = JSON.parse(resp)
        document.querySelector('#imgUser').src = imgExist ? `assets/users/${localStorage.getItem('idUser')}.jpg` : 'assets/user.jpeg'
    })



}

function fillPerfil(usr){

    const params = new Object;
        params.id =  usr

    const myPromisse = queryDB(params,27);
    myPromisse.then((resolve)=>{
        const json = JSON.parse(resolve)  
    
        const img = document.querySelector('#perfil-img') 

        img.src = `assets/users/${json[0].id}.jpg`
        breakImg(img)

        document.querySelector('#imgUser').src = img.src
        breakImg(document.querySelector('#imgUser'))

        document.querySelector('.perfil-seguindo').innerText = 'Seguindo '+json[0].SEGUINDO.padStart(2,0)
        document.querySelector('.perfil-seguidores').innerText = 'Seguidores '+json[0].SEGUIDORES.padStart(2,0)
        document.querySelector('.perfil-atividades').innerText = 'Atividades '+json[0].ATIVIDADES.padStart(2,0)
        document.querySelector('.perfil-nome').innerText = json[0].nome

    })


}

function breakImg(img){
    img.addEventListener('error',()=>{
        img.src = 'assets/user.jpeg'
    })   
}


function loadActivity(D,S,L){

    
    mainData.coords = new Object
    mainData.coords.lat = localStorage.getItem('lat')
    mainData.coords.lng = localStorage.getItem('lng')

    const screen = document.querySelector('.dashboard')
    S == '0' ? screen.innerHTML = '' : 0
    const params = new Object;
        params.lat =  mainData.coords.lat
        params.lng =  mainData.coords.lng
        params.maxDistance = D
        params.start = S
        params.limit = L

    const myPromisse = queryDB(params,9);
    myPromisse.then((resolve)=>{
        const json = JSON.parse(resolve)   
console.log(json)
        for(let i=0; i<json.length; i++){      
            const div = document.createElement('div')
            div.className = 'post-activity'
            div.id = `atv-${i}`
            div.innerHTML = `
            <div class="head-activity">
                <img class="imgUser head-activity-img" src="${`assets/users/${json[i].id_usuario}.jpg`}">
                <div>
                    <p class="head-activity-atleta">${json[i].ATLETA}</p>
                    <p class="head-activity-data">${json[i].dia.showDate()} as ${json[i].dia.showTime()}</p>
                </div>
            </div>
            <h2 id="nome">${json[i].nome}</h2>
            <h4 id="placar">${json[i].SETS_P1} x ${json[i].SETS_P2}</h4>           
            <div class="panel">
                <div class="left-panel">
                
                    <div class="map-view">
                    <div id="map-${i}" class="map-activity"></div>
                    <h6 class="map-label">${json[i].QUADRA}</h6>
                    </div>



                </div>
                <div class="right-panel">
                    <p id="sport">${json[i].SPORT} (${json[i].EVENTO})</p>  
<!--                                      
                    <a class="only-login ${localStorage.getItem('idUser') == null ? 'hide-menu' : ''}" style="display:flex; gap: 5px;" > Kudos   <i class="fas fa-thumbs-up"></i><span class="badge">${parseInt(json[i].KUDOS)>0 ? json[i].KUDOS : ''}</span></a>
                    <a class="only-login ${localStorage.getItem('idUser') == null ? 'hide-menu' : ''}" style="display:flex; gap: 5px;" > Scraps <i class="fas fa-comments"></i><span  class="badge">${parseInt(json[i].MESSAGES)>0 ? json[i].MESSAGES : ''}</span></a>
-->                    
                 
                    <div class="only-login ${localStorage.getItem('idUser') == null ? 'hide-menu' : ''}">
                        <!-- facebook -->
                        <a class="facebook" target="blank"><i class="fab fa-facebook"></i></a>
                        
                        <!-- twitter -->
                        <a class="twitter" target="blank"><i class="fab fa-twitter"></i></a>
                        
                        <!-- linkedin -->
                        <a class="linkedin" target="blank"><i class="fab fa-linkedin"></i></a>
                        
                        <!-- reddit -->
                        <a class="reddit" target="blank"><i class="fab fa-reddit"></i></a>

                        <!-- whatsapp-->
                        <a class="whatsapp" target="blank"><i class="fab fa-whatsapp"></i></a>

                        <!-- telegram-->
                        <a class="telegram" target="blank"><i class="fab fa-telegram"></i></a> 
                    </div> 
                    
                </div>
            </div>
            <div class="panel-social">
                <div id="numKudos-${i}" class="social-kudos">${json[i].KUDOS.padStart(2,0)} kudos</div>
                <div>
                    <button id="btnKudos-${i}"   class="btn-backhand btn-social"><i class="fas fa-thumbs-up"></i></button>
                    <button id="btnComment-${i}" class="btn-backhand btn-social"><i class="fas fa-comments"></i></button>
                </div>
            </div>            
            
            `

            div.database = json[i]
            screen.appendChild(div)
            maps.push(createMap('map-'+i,[json[i].lat, json[i].lng],30))

            pinMap([json[i].lat, json[i].lng],maps[maps.length-1])

            maps[maps.length-1].locate({setView: false, maxZoom: 30})
            disableMap(maps[maps.length-1])
            maps[maps.length-1].on('click',()=>{
                json[i].form = `atv-${i}`                    
                openHTML('viewTrainning.html','modal',json[i])
            })

            document.querySelector('#btnKudos-'+i).addEventListener('click',()=>{

                if(localStorage.getItem('idUser') != null){             
                    const params = new Object;
                        params.hash =  localStorage.getItem('hash')
                        params.id_atividade = json[i].id

                    const myPromisse = queryDB(params,18)

                    myPromisse.then((resolve)=>{                       
                        const kudos =  parseInt(JSON.parse(resolve)[0].KUDOS)
                        document.querySelector('#numKudos-'+i).innerHTML = kudos.toString().padStart(2,0)+ ' kudos'                                     
                    })
                }
            })

            document.querySelector('#btnComment-'+i).addEventListener('click',()=>{
                openHTML('message.html','modal',json[i])
            })
/*
            const link = encodeURI(window.location.href);
            const msg = encodeURIComponent('Hey, I found this article');
            const title = encodeURIComponent('Article or Post Title Here');

            const fb = document.querySelector('.facebook');
            fb.href = `https://www.facebook.com/share.php?u=${link}`;

            const twitter = document.querySelector('.twitter');
            twitter.href = `http://twitter.com/share?&url=${link}&text=${msg}&hashtags=javascript,programming`;

            const linkedIn = document.querySelector('.linkedin');
            linkedIn.href = `https://www.linkedin.com/sharing/share-offsite/?url=${link}`;

            const reddit = document.querySelector('.reddit');
            reddit.href = `http://www.reddit.com/submit?url=${link}&title=${title}`;

            const whatsapp = document.querySelector('.whatsapp');
            whatsapp.href = `https://api.whatsapp.com/send?text=${msg}: ${link}`;

            const telegram = document.querySelector('.telegram');
            telegram.href = `https://telegram.me/share/url?url=${link}&text=${msg}`;
*/



        }
    })
}

/*  ABAS */

function pictab(e){
    const tab = e.id
    const content = document.querySelectorAll(".tab");
    for (let i = 0; i < content.length; i++) {
        const sel_tab = document.querySelector('#tab-'+content[i].id)

        if(content[i].id == tab.split('-')[1]){
            content[i].style.display = "block"
            sel_tab.style.background = "#16a083";
            sel_tab.style.color = "#FFF8DC";
        }else{
            content[i].style.display = "none"
            sel_tab.style.background = "#FFF8DC";
            sel_tab.style.color = "#16a083";
        }
    }
}


/* VALIDATION */

function valInt(edt){
    edt.value = getNum(edt.value)
}

function getNum(V){
    const ok_chr = ['1','2','3','4','5','6','7','8','9','0'];
    let out = ''
    for(let i=0; i< V.length; i++){
        if(ok_chr.includes(V[i])){
            out+=V[i]
        }
    }
    return out
}

function getFone(V){
    let num = getNum(V)
    let out = '';
    for(i=0;i<num.length;i++){
        chr = num.substring(i,i+1);
        if(i == 0){
            out = '(' + out ;
        }
        if(i == 2){
            out = out + ')';
        }
        if(i == 6){
            out = out + '-';
        }
        if(i == 10){
            out = out.substring(0,5) +" "+out.substring(5,8)+out.substring(9,10)+"-"+out.substring(10,13)
        }		
        out = out + chr;			
    }
    return out
}

function phone(param){ 
    param.value = getFone(param.value)
}


function goon(F){
    let out = true
    const fields = F.split(',')

    for(let i=0; i<fields.length; i++){
        const txt = document.querySelector('#'+fields[i]).value.trim() == ''

        out = txt ? false : out
        txt ? document.querySelector('#'+fields[i]).focus() : 0

    }

    !out ? alert('Favor preencher todos os campos obrigatórios') : 0

    return out
}

function fillCombo(combo, params, cod, fields, value=''){

    combo = document.getElementById(combo)
    combo.innerHTML = ''
    const myPromisse = queryDB(params,cod);
    myPromisse.then((resolve)=>{
        const json = JSON.parse(resolve)        
        for(let i=0; i<json.length; i++){
            const opt = document.createElement('option')
            opt.value = json[i][fields[0]]
            opt.innerHTML = json[i][fields[1]].toUpperCase()
            opt.database = json[i]
            combo.appendChild(opt)
        }
        if(value != ''){
            combo.value = value
        }

    })

}


/* IMAGE */

function aspect_ratio(img,cvw=300, cvh=300){
    out = [0,0,cvw,cvh]
    w = img.width
    h = img.height
    
    if(w >= h){
        out[3] = cvh/(w/h)
        out[1] = (cvh - out[3]) / 2
    }else{
        out[2] = cvw/(h/w)
        out[0] = (cvw - out[2]) / 2
    }
    return out
}

function loadImg(filename, id='cnvImg') {

    var ctx = document.getElementById(id);
    if (ctx.getContext) {

        ctx = ctx.getContext('2d');
        var img = new Image();
        img.onload = function () {
            ar = aspect_ratio(img)
            ctx.drawImage(img, 0, 0,img.width,img.height,ar[0],ar[1],ar[2],ar[3]);
        };        
        img.src = filename;        
    
    }
}

function uploadImage(inputFile,path,filename){
    const up_data = new FormData();        
        up_data.append("up_file",  document.getElementById(inputFile).files[0]);
        up_data.append("path", path);
        up_data.append("filename", filename);

    const myRequest = new Request("backend/upload.php",{
        method : "POST",
        body : up_data
    });

    const myPromisse = new Promise((resolve,reject) =>{
        fetch(myRequest)
        .then(function (response){
            if (response.status === 200) { 
                resolve(response.text());                
            } else { 
                reject(new Error("Houve algum erro na comunicação com o servidor"));                    
            } 
        });
    }); 
}