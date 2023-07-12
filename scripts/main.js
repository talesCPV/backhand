/* GLOBAL DATA */ 

    var mainData = new Object
    const maps = []


/* FUNCTIONS */

function checkLogin(){
    let out = false
    if(localStorage.getItem('idUser') == null){
        document.querySelector('#log-inout').innerHTML = 'login'
        document.querySelector('#usr').innerHTML = ''
        hideMenu()
    }else{
        document.querySelector('#log-inout').innerHTML = 'logout'
        document.querySelector('#usr').innerHTML = localStorage.getItem('atleta')
        hideMenu(false)
        out = true
    }
    
    return out
}

function loadActivity(D,S,L){

    
    mainData.coords = new Object
    mainData.coords.lat = localStorage.getItem('lat')
    mainData.coords.lng = localStorage.getItem('lng')

    const screen = document.querySelector('#dashboard')
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

        for(let i=0; i<json.length; i++){
        
            const div = document.createElement('div')
            div.className = 'post-activity'
            div.id = `atv-${i}`
            div.innerHTML = `<p id="atleta">${json[i].ATLETA}</p>
            <h2 id="nome">${json[i].nome}</h2>
            <h4 id="placar">${json[i].nick} ${json[i].SETS_P1} vs ${json[i].SETS_P2} ${json[i].parceiro.split(' ')[0]}</h4>           
            <div class="panel">
                <div class="map-view">
                    <div id="map-${i}" class="map-activity"></div>
                    <h4 class="map-label">${json[i].QUADRA}</h4>
                </div>
                <div class="right-panel">
                    <p id="sport">Sport   - ${json[i].SPORT}</p>
                    <p id="evento">Event   - ${json[i].EVENTO}</p>
                    <a id="btnKudos-${i}" class="only-login ${localStorage.getItem('idUser') == null ? 'hide-menu' : ''}"> Kudos   <i class="fas fa-thumbs-up"></i></a><br>
                    <a id="btnComment-${i}" class="only-login ${localStorage.getItem('idUser') == null ? 'hide-menu' : ''}"> Comments <i class="fas fa-comments"></i></a>
                    
                    <br>
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
                    
                    <a id="btnViewMore-${i}">view more...</a>

                </div>
            </div>
            <div class="flex-line base-panel" >
                <div class="flex-col">
                    <h4>Date</h4>
                    <h4 id="data">${json[i].dia.showDate()}</h4>                    
                </div>
                <div class="flex-col">
                <h4>Time</h4>
                    <h4 id="hora">${json[i].dia.showTime()}</h4>                    
                </div>
                <div class="flex-col">
                    <h4>Elapsed Time</h4>
                    <h4 id="tempo">${parseInt(json[i].duracao/60).toString().padStart(2,'0')}:${parseInt(json[i].duracao%60).toString().padStart(2,'0')}</h4>                    
                </div>
            </div>
            `

            div.database = json[i]
            screen.appendChild(div)
            maps.push(createMap('map-'+i,[json[i].lat, json[i].lng],30))

            pinMap([json[i].lat, json[i].lng],maps[maps.length-1])

            maps[maps.length-1].locate({setView: false, maxZoom: 30})
//                maps[maps.length-1].zoomControl = false
            disableMap(maps[maps.length-1])
            maps[maps.length-1].on('click',()=>{
                json[i].form = `atv-${i}`                    
                openHTML('viewTrainning.html','modal',json[i])
            })

            document.querySelector('#btnViewMore-'+i).addEventListener('click',()=>{
                openHTML('viewTrainning.html','modal',json[i])
            })

            document.querySelector('#btnKudos-'+i).addEventListener('click',()=>{
                alert('Kudos: '+i)
            })

            document.querySelector('#btnComment-'+i).addEventListener('click',()=>{
                alert('Comment: '+i)
            })
        }
    })
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