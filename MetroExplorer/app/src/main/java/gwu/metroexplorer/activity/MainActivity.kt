package gwu.metroexplorer.activity

import android.content.Intent
import android.location.Location
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import com.example.will.metro_m.Model.MetroModel
import gwu.metroexplorer.R
import kotlinx.android.synthetic.main.activity_main.*



class MainActivity : AppCompatActivity(),FetchMetroStationMananger.LocationListCompletionListener,
        LocationDecter.LocationListener,
        FetchMetroStationMananger.LocationSearchCompletionListener{


    override fun locationListloaded(arr: ArrayList<MetroModel>) {

    }

    override fun locationListNotloaded() {

    }

    override fun locationListNotFound() {

    }

    override fun locationNotloaded() {

    }

    override fun locationNotFound() {

    }

    override fun locationFound(location: Location) {

    }

    override fun locationNotFound(location: LocationDecter.FailureReason) {

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        //start MetroStationsActivity
        select_station.setOnClickListener{
            val i = Intent(this@MainActivity, MetroStationsActivity::class.java)
            startActivity(i)
        }

        //start FavoritesActivity
        favorites.setOnClickListener{
            val i = Intent(this@MainActivity, FavoritesActivity::class.java)
            startActivity(i)
        }

        nearest_station.setOnClickListener{
            val arr:String = "none"
            val i  = Intent(this@MainActivity, Near::class.java)
//            var nearest_station = locationloaded(arr)
            startActivity(i)

        }
    }
    override fun locationloaded(arr: String) {

        //arr is the value of the nearest station
        print("nearest metro station:"+arr)
    }
}
