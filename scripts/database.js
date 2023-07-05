/*  DATABASE  */

function queryDB(params,cod){
    const data = new URLSearchParams();        
        data.append("cod", cod);
        data.append("params", JSON.stringify(params));
        data.append("storage", localStorage.getItem("storage"));

    const myRequest = new Request("backend/query_db.php",{
        method : "POST",
        body : data
    });

    return new Promise((resolve,reject) =>{
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

function rowsAffect(params,cod){
    const data = new URLSearchParams();        
        data.append("cod", cod);
        data.append("params", JSON.stringify(params));
        data.append("storage", localStorage.getItem("storage"));

    const myRequest = new Request("backend/rowsaffect.php",{
        method : "POST",
        body : data
    });

    return new Promise((resolve,reject) =>{
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