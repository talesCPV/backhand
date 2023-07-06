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

    const screen = document.querySelector('#dashboard')
    S == '0' ? screen.innerHTML = '' : 0
    const params = new Object;
        params.lat = localStorage.getItem('lat')
        params.lng = localStorage.getItem('lng')
        params.maxDistance = D
        params.start = S
        params.limit = L

    const myPromisse = queryDB(params,9);
    myPromisse.then((resolve)=>{
        const json = JSON.parse(resolve)  
        for(let i=0; i<json.length; i++){
            
            const div = document.createElement('div')
            div.className = 'post-activity'

            div.innerHTML = `<p>${json[i].ATLETA}</p>
            <h2>${json[i].nome}</h2>
            <h4>${json[i].dia.showDate()} ${json[i].dia.showTime()} - ${json[i].QUADRA}</h4>
            <div style="display:flex; gap:20px;">
                <div id="map-${i}" class="map-activity"></div>
                <div>
                    <h2></h2>
                    <p>Partner - ${json[i].parceiro}</p>
                    <p>Sport   - ${json[i].SPORT}</p>
                    <p>Event   - ${json[i].EVENTO}</p>
                    <a class="only-login ${localStorage.getItem('idUser') == null ? 'hide-menu' : ''}"> Kudos <i class="fas fa-thumbs-up"></i></a>
                    <br>
                    <a id="btnViewMore-${i}">view more...</a>
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
                </div>
            </div>`
//            console.log(json[i].distance)      

            div.database = json[i]
            screen.appendChild(div)
            maps.push(createMap('map-'+i,[json[i].lat, json[i].lng],30))

            pinMap([json[i].lat, json[i].lng],maps[maps.length-1])

            maps[maps.length-1].locate({setView: false, maxZoom: 30})
            maps[maps.length-1].zoomControl = false
            maps[maps.length-1].on('click',()=>{
                openHTML('viewTrainning.html','modal',json[i])
            })

            document.querySelector('#btnViewMore-'+i).addEventListener('click',()=>{
                openHTML('viewTrainning.html','modal',json[i])
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