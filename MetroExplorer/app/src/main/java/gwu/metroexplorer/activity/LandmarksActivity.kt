package gwu.metroexplorer.activity

import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.support.v7.widget.LinearLayoutManager
import android.widget.LinearLayout
import gwu.metroexplorer.R
import gwu.metroexplorer.adapter.LandmarksAdapter
import gwu.metroexplorer.model.Landmarks
import gwu.metroexplorer.model.LandmarksModel

import kotlinx.android.synthetic.main.activity_landmarks.*



class LandmarksActivity: AppCompatActivity() {


    var names = ArrayList<Landmarks>()
    var landmarksAdapter = LandmarksAdapter(names)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_landmarks)

        var i = this.intent
        names.add(Landmarks(i.getStringExtra("name"),0.0,0.0))

        //recyclerview settings
        landmarks_recyclerview.layoutManager= LinearLayoutManager(this, LinearLayout.VERTICAL, false)
        landmarks_recyclerview.adapter = landmarksAdapter

    }
}
