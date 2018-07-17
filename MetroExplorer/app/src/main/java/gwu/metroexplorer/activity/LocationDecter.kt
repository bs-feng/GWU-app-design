package gwu.metroexplorer.activity

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.location.Location
import android.support.v4.app.ActivityCompat
import android.support.v4.content.ContextCompat
import android.support.v4.content.ContextCompat.checkSelfPermission
import android.support.v7.app.AppCompatActivity
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationResult
import org.jetbrains.anko.toast
import java.util.*
import kotlin.concurrent.timerTask


class LocationDecter(val context: Context): AppCompatActivity() {
    val fusedLocationClient: FusedLocationProviderClient = FusedLocationProviderClient(context)

    enum class FailureReason{
        TIMEOUT,
        NO_PERMISSION
    }
    var locationListener: LocationListener? = null

    interface LocationListener{
        fun locationFound(location : Location)
        fun locationNotFound(location: FailureReason)
    }

    @SuppressLint("MissingPermission")

    fun requestPermissionIFnecessary(){
        //check location
        val checkSelfPermission = ContextCompat.checkSelfPermission(context, android.Manifest.permission.ACCESS_FINE_LOCATION)
        if(checkSelfPermission != PackageManager.PERMISSION_GRANTED){
            val LOCATION_PERMISSION_REQUEST_CODE = 777
            ActivityCompat.requestPermissions(context as Activity, arrayOf(android.Manifest.permission.ACCESS_FINE_LOCATION),
                    LOCATION_PERMISSION_REQUEST_CODE)
        }
    }

    override  fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        //if user declines location permission, let them know that there will be consequences :)
        val LOCATION_PERMISSION_REQUEST_CODE = 777
        if(requestCode == LOCATION_PERMISSION_REQUEST_CODE) {
            if(grantResults.isNotEmpty() && grantResults.first() != PackageManager.PERMISSION_GRANTED) {
                toast ("You have to give GPS permission to this application in order to use all the service")
            }
        }
    }

    @SuppressLint("MissingPermission")
    fun detectLocation(){
        requestPermissionIFnecessary()
        //create location request
        val locationRequest = LocationRequest()
        locationRequest.interval = 0L

        //check for location premission
        val permissionResult = checkSelfPermission(context,
                Manifest.permission.ACCESS_FINE_LOCATION)
        //if location permission granted, proceed with location detection
        if(permissionResult == android.content.pm.PackageManager.PERMISSION_GRANTED) {

            //create location detection callback
            val locationCallback = object : LocationCallback() {
                override fun onLocationResult(locationResult: LocationResult) {
                    //stop location updates
                    fusedLocationClient.removeLocationUpdates(this)

                    //fire callback with location
                    locationListener?.locationFound(locationResult.locations.first())
                }
            }

            //start a timer to ensure location detection ends after 10 seconds
            val timer = Timer()
            timer.schedule(timerTask {
                //if timer expires, stop location updates and fire callback
                fusedLocationClient?.removeLocationUpdates(locationCallback)
                locationListener?.locationNotFound(FailureReason.TIMEOUT)
            }, 10*1000) //10 seconds


            //start location updates
            fusedLocationClient.requestLocationUpdates(locationRequest,locationCallback, null)
        }
        else {
            //else if no permission, fire callback
            locationListener?.locationNotFound(FailureReason.NO_PERMISSION)
        }
    }

}