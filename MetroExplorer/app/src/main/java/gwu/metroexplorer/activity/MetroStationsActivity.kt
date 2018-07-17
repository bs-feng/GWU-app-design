package gwu.metroexplorer.activity

import android.os.Bundle
import android.support.v4.view.MenuItemCompat
import android.support.v7.app.AppCompatActivity
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.SearchView
import android.view.Menu
import android.widget.LinearLayout
import com.example.will.metro_m.Model.MetroModel
import gwu.metroexplorer.R
import gwu.metroexplorer.adapter.MetroStationsAdapter
import kotlinx.android.synthetic.main.activity_metro_stations.*



class MetroStationsActivity : AppCompatActivity() , SearchView.OnQueryTextListener, FetchMetroStationMananger.LocationListCompletionListener {



    var metroStationsAllList = ArrayList<MetroModel>()
    lateinit var metroStationsAdapter:MetroStationsAdapter

   // var metroList: JsonArray = null
    override fun locationListloaded(arr: ArrayList<MetroModel>) {

       metroStationsAdapter = MetroStationsAdapter(arr)
       metrostations_recyclerview.adapter = metroStationsAdapter
       metroStationsAllList = arr

    }

    override fun locationListNotloaded() {
    }

    override fun locationListNotFound() {
    }


    //var names = ArrayList<String>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_metro_stations)

        // fetch metro data
        val fetchMetro = FetchMetroStationMananger(this)
        fetchMetro.locationListCompletionListener = this
        fetchMetro.metro_list()

        //recyclerview adapter

        metrostations_recyclerview.layoutManager = LinearLayoutManager(this, LinearLayout.VERTICAL, false)
        metrostations_recyclerview.setHasFixedSize(true)
        //metrostations_recyclerview.adapter = metroStationsAdapter

        //toolbar search
        setSupportActionBar(metrostations_toolbar)
    }

        //toolbar
        override fun onCreateOptionsMenu(menu: Menu?): Boolean {
            menuInflater.inflate(R.menu.metro_stations_search, menu)

            var searchItem = menu?.findItem(R.id.metrostations_search)
            var searchView = MenuItemCompat.getActionView(searchItem) as SearchView
            searchView.setOnQueryTextListener(this)
            return true
        }

        //recyclerview filter listener
        override fun onQueryTextSubmit(query: String?): Boolean {
            return false
        }

        override fun onQueryTextChange(newText: String?): Boolean {
            var text = newText.toString().toLowerCase()

            //filter algorithms
            var newList = ArrayList<MetroModel>()
            for (item in metroStationsAllList) {
                val name = item.Name.toLowerCase()
                if (name.contains(text))
                    newList.add(item)
            }
      metroStationsAdapter.setFilter(newList)
       return true
    }

}



