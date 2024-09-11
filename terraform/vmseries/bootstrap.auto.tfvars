bootstrap_options = {
    auth-key                              = "changeme" // Replace with your authcode from CSP Deployment Profile
    dgname                                = "changeme" // Must match your folder name in SCM
    vm-series-auto-registration-pin-id    = "changeme" // Replace with your PIN ID from CSP. Required for SCM
    vm-series-auto-registration-pin-value = "changeme" // Replace with your PIN Value from CSP. Required for SCM
    mgmt-interface-swap                   = "enable"   // Interface swap isn't really required anymore but is still a convention for GWLB
    panorama-server                       = "cloud"    // This is a special keyword to bootstrap to SCM
    plugin-op-commands                    = "aws-gwlb-inspect:enable,aws-gwlb-overlay-routing:enable"

    # Any other bootstrap parameters can be added here.
}
