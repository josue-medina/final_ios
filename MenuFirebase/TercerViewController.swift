import UIKit
import MapKit
import CoreLocation

class TercerViewController: UIViewController, MKMapViewDelegate {
    
    var manager = CLLocationManager()
    var latitud:CLLocationDegrees?
    var longitud:CLLocationDegrees?
    var altitud:Double?
    
    @IBOutlet weak var mapa: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        mapa.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let localizacion = CLLocationCoordinate2D(latitude: latitud ?? 0, longitude: longitud ?? 0)
        let spanMapa = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.04)
        let region = MKCoordinateRegion(center: localizacion, span: spanMapa)
        
        mapa.setRegion(region, animated: true)
        mapa.showsUserLocation = true
        
        let geocoder = CLGeocoder()
        
        
        let rutaDestino = "Estadio Azteca"
        geocoder.geocodeAddressString(rutaDestino) { [self] (places: [CLPlacemark]?,error: Error?) in
        //crear destino
        guard let destinoRuta = places?.first?.location else{return}
        if error == nil{
            let lugar = places?.first
            let anotacion = MKPointAnnotation()
            anotacion.coordinate = (lugar?.location?.coordinate)!
            anotacion.title = rutaDestino
                    
            //span o nivel de zoom
            let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            let region = MKCoordinateRegion(center: anotacion.coordinate, span: span)
                    
            self.mapa.setRegion(region, animated: true)
            self.mapa.addAnnotation(anotacion)
            self.trazarRuta(coordenadasDestino: destinoRuta.coordinate)
            }
            else{
                print("Error en direccion")
            }
        }
    }
    
    func trazarRuta(coordenadasDestino: CLLocationCoordinate2D) {
        guard let coordOrigen = manager.location?.coordinate else { return }
        let origenPlaceMark = MKPlacemark(coordinate: coordOrigen)
        let destinoPlaceMark = MKPlacemark(coordinate: coordenadasDestino)
        
        let origenItem = MKMapItem(placemark: origenPlaceMark)
        let destinoItem = MKMapItem(placemark: destinoPlaceMark)
        
        let solicitudDestino = MKDirections.Request()
        solicitudDestino.source = origenItem
        solicitudDestino.destination = destinoItem
        
        solicitudDestino.transportType = .automobile
        solicitudDestino.requestsAlternateRoutes = true
        
        let direccciones = MKDirections(request: solicitudDestino)
        direccciones.calculate { (respuesta, error) in
            guard let respuestaSegura = respuesta else{
                if let error = error{
                    print("Error al calcular la ruta\(error.localizedDescription)")
                    
                    let alerta = UIAlertController(title: "error", message: "Ruta inalcanzable", preferredStyle: .alert)
                    let accionOk = UIAlertAction(title: "ok", style: .default)
                    
                    alerta.addAction(accionOk)
                    self.present(alerta, animated: true)
                }//
                return
            }//respuesta segura
            if let ruta = respuestaSegura.routes.first{
                self.mapa.addOverlay(ruta.polyline)
                self.mapa.setVisibleMapRect((ruta.polyline.boundingMapRect), animated: true)
            }
        }
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderizado = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderizado.strokeColor = .red
        return renderizado
    }
    
}
extension TercerViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("numero de ubicaciones \(locations.count)")
        //crear ubicacion
        guard let ubicacion = locations.first else {return}
        latitud = ubicacion.coordinate.latitude
        longitud = ubicacion.coordinate.longitude
        altitud = ubicacion.altitude
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error al obtener ubicacion")
        let alerta = UIAlertController(title: "error", message: "Al obtener ubicacion", preferredStyle: .alert)
        let accionOk = UIAlertAction(title: "ok", style: .default)
        
        alerta.addAction(accionOk)
        present(alerta, animated: true)
    }
}
