package gwu.metroexplorer.activity

import android.location.Location
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import com.google.gson.JsonArray
import gwu.metroexplorer.R
import kotlinx.android.synthetic.main.activity_near.*


class Near : AppCompatActivity(), FetchMetroStationMananger.nearSearchCompletionListener, LocationDecter.LocationListener, FetchMetroStationMananger.LocationSearchCompletionListener{

    override fun locationloaded(arr: String) {

        //arr is the value of the nearest station
        print("nearest metro station:"+arr)
        textView.text = arr
    }

    override fun locationloaded(arr: JsonArray) {


    }

    override fun locationFound(location: Location) {

        val fetchNearestMetroStation = FetchMetroStationMananger(this)
        fetchNearestMetroStation.locationSearchCompletionListener = this
        fetchNearestMetroStation.near(location.latitude.toString(),location.longitude.toString())
    }

    override fun locationNotloaded() {

    }

    override fun locationNotFound(location: LocationDecter.FailureReason) {

    }

    override fun locationNotFound() {

    }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_near)
        val locationDect = LocationDecter(this)
        locationDect.locationListener = this
        locationDect.detectLocation()

    }

}
