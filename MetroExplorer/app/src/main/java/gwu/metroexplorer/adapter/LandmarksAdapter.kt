package gwu.metroexplorer.adapter

import android.content.Intent
import android.support.v7.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import gwu.metroexplorer.Interface.CustomItemClickListener
import gwu.metroexplorer.R
import gwu.metroexplorer.activity.LandmarkDetailActivity
import gwu.metroexplorer.model.Landmarks

//Created and edited by Baosheng Feng

class LandmarksAdapter(var nameList: ArrayList<Landmarks>): RecyclerView.Adapter<LandmarksAdapter.ViewHolder>() {
    override fun onBindViewHolder(holder: ViewHolder?, position: Int) {
        holder?.bind(nameList[position])
        holder?.setOnCustomItemClickListener(object: CustomItemClickListener{
            override fun onCustomItemClickListener(view: View, position: Int) {
                var i = Intent(view.context, LandmarkDetailActivity::class.java)
                i.putExtra("name",nameList[position].name)
                view.context.startActivity(i)
            }
        })
    }

    override fun getItemCount(): Int {
        return nameList.count()
    }

    override fun onCreateViewHolder(parent: ViewGroup?, viewType: Int): ViewHolder{
        val layoutInflater = LayoutInflater.from(parent?.context)
        return ViewHolder(layoutInflater.inflate(R.layout.row_landmark, parent, false))
    }

    inner class ViewHolder(itemView: View): RecyclerView.ViewHolder(itemView), View.OnClickListener{

        var customItemClickListener: CustomItemClickListener? = null
        init {
            itemView.setOnClickListener(this)

        }

        fun setOnCustomItemClickListener(itemClickListener: CustomItemClickListener){
            this.customItemClickListener = itemClickListener
        }

        override fun onClick(p0: View?) {
            this.customItemClickListener!!.onCustomItemClickListener(p0!!, adapterPosition)
        }


        fun bind(name: Landmarks){
            val nameTextView: TextView = itemView.findViewById(R.id.landmark_name)
            nameTextView.text = name.name
        }
    }

}