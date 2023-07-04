/* GLOBAL DATA */ 

    var mainData = new Object

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