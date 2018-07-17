package gwu.metroexplorer.activity

import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.support.v7.widget.LinearLayoutManager
import android.widget.LinearLayout
import gwu.metroexplorer.R
import gwu.metroexplorer.adapter.FavoritesAdapter
import kotlinx.android.synthetic.main.activity_favorites.*



class FavoritesActivity : AppCompatActivity() {

    var names = ArrayList<String>()
    var favoritesAdapter = FavoritesAdapter(names)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_favorites)

        //get names from SharedPreferences
        var setting = getSharedPreferences("MetroExplorer",0)
        for(item in setting.all)
            names.add(item.key)

        //recyclerview settings
        favorites_recyclerview.layoutManager = LinearLayoutManager(this, LinearLayout.VERTICAL, false)
        favorites_recyclerview.adapter = favoritesAdapter
    }

}
