var mbAttr = 'www.backhand.com.br';
var mapUrl = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';    
var satUrl = 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
//var marker = new L.Marker([0, 0]);

maplayer = L.tileLayer(mapUrl, {
    id: 'mapbox.streets',
    attribution: mbAttr
});

satlayer = L.tileLayer(satUrl, {
    id: 'mapbox.streets',
    attribution: mbAttr
});

function createMap(idMap, setview = [0,0], zoom=30){

    const layer = L.tileLayer(satUrl, {
        id: 'mapbox.streets',
        attribution: mbAttr
    });

    const myMap = L.map(idMap, {
        center: [30, 0],
        zoom: zoom,
        layers: [layer]
    }).setView(setview, zoom)

    myMap.removeLayer(satlayer);
    myMap.removeLayer(maplayer);
    myMap.addLayer(satlayer);

    if(setview[0] == 0){
        myMap.locate({setView: true, maxZoom: 16});
    }else{
        myMap.locate({setView: setview, maxZoom: zoom});
    }

    return myMap

}

function pinMap(latlng,map){
    var marker = new L.Marker(latlng);
    marker.addTo(map)
}
