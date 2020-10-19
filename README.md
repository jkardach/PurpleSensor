# PurpleSensor

This package provides the interface to a purple air sensors from Swift and ObjC returning
the name of the sensor, humidity, temperature, pressure, and the air quality index (
current value and several types of running averages).

The sensor to take the reading from is identified by two values:
    device ID ("ID" in the JSON)
   Thinkspeak primary id read key ("THINGSPEAK_PRIMARY_ID_READ_KEY" in JSON)
    
These values can be obtained from purple air map, where you context click on the sensor,
scroll to the button of the pop-up where it says "Get This Widget".  Clicking on this gives
another pop-up menu where you can click JSON which shows the fields.

For example  "79963" is the device ID of the saratoga swim club's sensor, and "PLAU2B5XC0FSICZR"
is the thinkspeak primary id read key.  These can be modified for the particular sensor you 
want to use.

The interface is pretty easy to use, in that you conform to the protocol, and call the
performRequest(id: String, thinkspeakKey: String).

When the update is finished the protocol method
    didUpdatePurple(_ purple: PurpleModel), or 
    func didFailWithError(_ error: Error)

are called.  The data is returned in an object of PurpleModel which has properties for 
each of the sensor values.

The library can be used by swift programs or objective-c programs.

## Swift Programs Example


```
import UIKit
import PurpleSensor

class ViewController: UIViewController, UpdatePurpleDelegate {

    
    
    var purpleManager = PurpleManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        purpleManager.delegate = self
        purpleManager.performRequest(id: "79963", thinkspeakKey: "PLAU2B5XC0FSICZR")
    }
    
    func didUpdatePurple(_ purple: PurpleModel) {
        print("purple location: \(purple.name)")
        print("humidity: \(purple.humidity) %")
        print("temperature: \(purple.temp) F")
        print("pressure: \(purple.pressure) millibars")
        print("air quality: \(purple.PMcurrent) ")
        print("AQ: \(purple.AQ)")
        print("AQ Description: \(purple.AQDescription)")
        print("AQ Message: \(purple.AQMessage)")
        
        print("AQ10min: \(purple.AQ10min)")
        print("AQ10min Description: \(purple.AQ10minDescription)")
        print("AQ10min Message: \(purple.AQ10minMessage)")
        
        print("AQ30min: \(purple.AQ30min)")
        print("AQ30min Description: \(purple.AQ30minDescription)")
        print("AQ30min Message: \(purple.AQ30minMessage)")
        
        print("AQ1hr: \(purple.AQ1hr)")
        print("AQ1hr Description: \(purple.AQ1hrDescription)")
        print("AQ1hr Message: \(purple.AQ1hrMessage)")
        
        print("AQ6hr: \(purple.AQ6hr)")
        print("AQ6hr Description: \(purple.AQ6hrDescription)")
        print("AQ6hr Message: \(purple.AQ6hrMessage)")
        
        print("AQ24hr: \(purple.AQ24hr)")
        print("AQ24hr Description: \(purple.AQ24hrDescription)")
        print("AQ24hr Message: \(purple.AQ24hrMessage)")
        
        print("AQ1week: \(purple.AQ1week)")
        print("AQ1week Description: \(purple.AQ1weekDescription)")
        print("AQ1week Message: \(purple.AQ1weekMessage)")
        
    }
    
    func didFailWithError(_ error: Error) {
        print("Error \(error.localizedDescription)")
    }
}
```
## Swift Program Output
```
purple location: Saratoga Swim Club
humidity: 51 %
temperature: 60 F
pressure: 999.01 millibars
air quality:  
AQ: 31.0
AQ Description: Good
AQ Message: 0-50: Air quality is considered satisfactory, and air pollution poses little or no risk
AQ10min: 28.0
AQ10min Description: Good
AQ10min Message: 0-50: Air quality is considered satisfactory, and air pollution poses little or no risk
AQ30min: 26.0
AQ30min Description: Good
AQ30min Message: 0-50: Air quality is considered satisfactory, and air pollution poses little or no risk
AQ1hr: 26.0
AQ1hr Description: Good
AQ1hr Message: 0-50: Air quality is considered satisfactory, and air pollution poses little or no risk
AQ6hr: 35.0
AQ6hr Description: Good
AQ6hr Message: 0-50: Air quality is considered satisfactory, and air pollution poses little or no risk
AQ24hr: 30.0
AQ24hr Description: Good
AQ24hr Message: 0-50: Air quality is considered satisfactory, and air pollution poses little or no risk
AQ1week: 10.0
AQ1week Description: Good
AQ1week Message: 0-50: Air quality is considered satisfactory, and air pollution poses little or no risk
```
## Objective-C Program Example

```
#import "ViewController.h"
@import PurpleSensor

@interface ViewController () <UpdatePurpleDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PurpleManager *purpleManager = [[PurpleManager alloc] init];
    purpleManager.delegate = self;
    [purpleManager performRequestWithId:@"79963" thinkspeakKey:@"PLAU2B5XC0FSICZR"];
}

-(void)didUpdatePurple:(PurpleModel *)purple {
    NSLog(@"purple.name: %@", purple.name);
    NSLog(@"purple.humidity: %@", purple.humidity);
}

-(void)didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
}

@end
```
## Objective-C Output Example

```
2020-10-19 08:23:06.982584-0700 ObjCApp[78655:2435338] purple.name: Saratoga Swim Club
2020-10-19 08:23:06.982840-0700 ObjCApp[78655:2435338] purple.humidity: 51
```
