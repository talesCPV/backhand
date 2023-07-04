var modal = document.getElementById("myModal");

async function openHTML(  template="",where="modal", data=null, max='',){

  if(template.trim() != ""){
      return await new Promise((resolve,reject) =>{
          fetch( "templates/"+template)
          .then( stream => stream.text())
          .then( text => {
              const temp = document.createElement('div');
              temp.name = template
              temp.innerHTML = text;
              const err = temp.getElementsByTagName('template')[0] == undefined ? true : false
                if(err){
                    temp.innerHTML = '<title>ERROR 404!</title><template></template><script></script>'
                }  


                if(where == "modal"){
                    mainData[template.split('.')[0]] = new Object
                    data != null ? mainData[template.split('.')[0]].data = data : 0
                    newModal(temp,max)
                }else{

//                    document.querySelector('#dashboard').innerHTML = temp.getElementsByTagName('title')[0].innerHTML
                    document.querySelector('#dashboard').innerHTML = temp.getElementsByTagName('template')[0].innerHTML
                    eval(temp.getElementsByTagName('script')[0].innerHTML);                                  
//                    document.getElementById("myModal").style.display = "block";  
                    
                }
                
          }); 
      }); 
  }
}

function closeModal(id='all'){
    const mod_main = document.querySelector('#myModal')
    if(id=='all'){
        while(mod_main.querySelectorAll('.modal').length > 0){
            mod_main.querySelectorAll('.modal')[0].remove()    
        }
    }else{
        id = (id=='')? mod_main.querySelectorAll('.modal').length-1 : id
        delete mainData[mod_main.querySelector('#modal-'+id).name] 
        mod_main.querySelector('#modal-'+id).remove()
//        delete main_data[id]
    }
    mod_main.style.display = (mod_main.querySelectorAll('.modal').length < 1) ? "none" : 'block'
//    checkMail()
}

function newModal(content, max=0){
    const mod_main = document.querySelector('#myModal')
    const index = mod_main.querySelectorAll('.modal-content').length        
    const offset = 15

    const backModal = document.createElement('div')
        backModal.classList = 'modal'
        backModal.id = 'modal-'+index
        backModal.name = content.name
        backModal.style.zIndex = 12+index
        backModal.style.display = 'block'

    const mod_card = document.createElement('div')
        mod_card.classList = 'modal-content'
//        mod_card.id = 'card-0'        
        mod_card.style.position = 'absolute'
        mod_card.style.zIndex = 13+index
        mod_card.style.margin = '0 auto'
        mod_card.style.top =  50 + index*offset+'px'
        mod_card.style.left =  index*offset+'px'
        mod_card.style.right =  index*offset+'px'
//        mod_card.style['max-width'] = max==0 ? '80%' : max
    
    const mod_title = document.createElement('div')
    mod_title.className = 'modal-header'    
    const h2 = document.createElement('h2')
    h2.className = 'title-'+content.name.split('.')[0]
    h2.innerHTML = content.getElementsByTagName('title')[0].innerHTML
    mod_title.appendChild(h2)

    const span = document.createElement('span')
    span.classList = 'close'
    span.innerHTML = '&times;'
    span.addEventListener('click',()=>{
        closeModal(0)
    })
    mod_title.appendChild(span)
    mod_card.appendChild(mod_title)

    const mod_content = document.createElement('div')
    mod_content.classList = 'md-body'
    mod_content.innerHTML = content.getElementsByTagName('template')[0].innerHTML
    mod_card.appendChild(mod_content)    

    backModal.appendChild(mod_card)
    
    mod_main.appendChild(backModal)
    mod_main.style.display = "block"


    eval(content.getElementsByTagName('script')[0].innerHTML)

}
