import '../auth/auth_util.dart';
import '../backend/backend.dart';
import '../components/host_bottom_sheet_widget.dart';
import '../flutter_flow/flutter_flow_google_map.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  LatLng googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng currentUserLocationValue;

  @override
  void initState() {
    super.initState();
    getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0), cached: true)
        .then((loc) => setState(() => currentUserLocationValue = loc));
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserLocationValue == null) {
      return Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            color: FlutterFlowTheme.of(context).primaryColor,
          ),
        ),
      );
    }
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: StreamBuilder<List<ProposalsRecord>>(
                stream: queryProposalsRecord(),
                builder: (context, snapshot) {
                  // Customize what your widget looks like when it's loading.
                  if (!snapshot.hasData) {
                    return Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          color: FlutterFlowTheme.of(context).primaryColor,
                        ),
                      ),
                    );
                  }
                  List<ProposalsRecord> googleMapProposalsRecordList =
                      snapshot.data;
                  return FlutterFlowGoogleMap(
                    controller: googleMapsController,
                    onCameraIdle: (latLng) => googleMapsCenter = latLng,
                    initialLocation: googleMapsCenter ??=
                        currentUserLocationValue,
                    markers: (googleMapProposalsRecordList ?? [])
                        .map(
                          (googleMapProposalsRecord) => FlutterFlowMarker(
                            googleMapProposalsRecord.reference.path,
                            googleMapProposalsRecord.location,
                            () async {
                              await showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: MediaQuery.of(context).viewInsets,
                                    child: HostBottomSheetWidget(
                                      proposal: googleMapProposalsRecord,
                                    ),
                                  );
                                },
                              );
                              setState(() => FFAppState()
                                  .usersForChat
                                  .add(currentUserReference));
                              setState(() => FFAppState()
                                  .usersForChat
                                  .add(googleMapProposalsRecord.host));
                            },
                          ),
                        )
                        .toList(),
                    markerColor: GoogleMarkerColor.blue,
                    mapType: MapType.normal,
                    style: GoogleMapStyle.standard,
                    initialZoom: 14,
                    allowInteraction: true,
                    allowZoom: true,
                    showZoomControls: true,
                    showLocation: true,
                    showCompass: true,
                    showMapToolbar: false,
                    showTraffic: false,
                    centerMapOnMarkerTap: true,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
