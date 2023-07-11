
/* close mobile menu when choose */

for(let i=0; i<document.querySelectorAll('.menu-items li').length; i++){
    document.querySelectorAll('.menu-items li')[i].addEventListener('click',()=>{
        document.querySelector('#ckbHamb').checked = false
    })
}


function hideMenu(hide=true){
    const menu = document.querySelectorAll('.only-login')
    for(let i=0; i<menu.length; i++){
        hide ? menu[i].classList.add('hide-menu') : menu[i].classList.remove('hide-menu')
    }
}