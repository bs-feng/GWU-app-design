package gwu.metroexplorer.activity

import android.content.Intent
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.view.Menu
import android.view.MenuItem
import android.widget.TextView
import gwu.metroexplorer.R
import kotlinx.android.synthetic.main.activity_landmark_detail.*
import org.jetbrains.anko.toast



class LandmarkDetailActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_landmark_detail)

        setSupportActionBar(landmarkdetail_toolbar)

        //landmarkdetail information
        var i =this.intent
        var landmarkName = i.extras.getString("name")

        var landmarkDetailText = findViewById<TextView>(R.id.landmarkdetail_text)
        landmarkDetailText.setText(landmarkName)


    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        menuInflater.inflate(R.menu.landmark_detail_function, menu)
        return true
    }

    //share function
    fun shareLandmark(item : MenuItem){
        var sendIntent = Intent()
        sendIntent.setAction(Intent.ACTION_SEND)
        var text = getString(R.string.share_word_one) + this.intent.extras.getString("name") + getString(R.string.share_word_two)
        sendIntent.putExtra(Intent.EXTRA_TEXT, text)
        sendIntent.setType("text/plain")
        startActivity(sendIntent)
    }


    /*   Add landmark to favorites function
    if the landmark has already been in the favorites, it will be removed and you will get the notification
    if the landmark is not in the favorites, it will be added to the favorites and you will get the notification
    then you can find the updated favorites in the favorites activity

    WARNING!:
    if you go to the landmark detail by the path:
    Favorites(MainActivity) -> Favorites List(FavoritesActivity) -> Landmark Detail(LandmarkDetailActivity)
    and you click the favorite button, you should go back to the MainActivity first, then choose "Favorites" button to FavoritesActivity
    then you can get the updated favorites list.
     */
    fun addToFavorite(item: MenuItem){

        //SharedPreferences
        var name = this.intent.extras.getString("name")
        var setting = getSharedPreferences("MetroExplorer",0)
        val editor = setting.edit()

        //add or remove landmark detail name
        if(setting.contains(name)){
            editor.remove(name)
            editor.commit()
            toast(R.string.favorite_del)
        }
        else{
            editor.putString(name, name)
            editor.commit()
            toast(R.string.favorite_add)
        }
    }

    fun openMap(item: MenuItem){
        val i = Intent(this,MapsActivity::class.java)
        startActivity(i)

    }

}
