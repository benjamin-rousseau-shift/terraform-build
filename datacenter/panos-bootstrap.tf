# Gathering Bootstrap storage Account & File share data
data "azurerm_storage_account" "bootstrap-storage-acct" {
  name                = var.bootstrap_storage_account
  resource_group_name = var.bootstrap_resource_group
}

data "azurerm_storage_share" "bootstrap-storage-share" {
  name                 = var.bootstrap_storage_share
  storage_account_name = data.azurerm_storage_account.bootstrap-storage-acct.name
}

# Generating my bootstrap.xml
resource "local_file" "bootstrap" {
  content  = <<EOT
<?xml version="1.0"?>
<config version="9.1.0" urldb="paloaltonetworks">
  <mgt-config>
    <users>
      <entry name="admin">
        <phash>*</phash>
        <permissions>
          <role-based>
            <superuser>yes</superuser>
          </role-based>
        </permissions>
      </entry>
      <entry name="windu">
        <phash>$1$bwoupkin$96Z8YDf6lRX4VDqa7uSX81</phash>
        <permissions>
          <role-based>
            <superuser>yes</superuser>
          </role-based>
        </permissions>
      </entry>
    </users>
    <password-complexity>
      <enabled>yes</enabled>
      <minimum-length>8</minimum-length>
    </password-complexity>
  </mgt-config>
  <shared>
    <application/>
    <application-group/>
    <service/>
    <service-group/>
    <botnet>
      <configuration>
        <http>
          <dynamic-dns>
            <enabled>yes</enabled>
            <threshold>5</threshold>
          </dynamic-dns>
          <malware-sites>
            <enabled>yes</enabled>
            <threshold>5</threshold>
          </malware-sites>
          <recent-domains>
            <enabled>yes</enabled>
            <threshold>5</threshold>
          </recent-domains>
          <ip-domains>
            <enabled>yes</enabled>
            <threshold>10</threshold>
          </ip-domains>
          <executables-from-unknown-sites>
            <enabled>yes</enabled>
            <threshold>5</threshold>
          </executables-from-unknown-sites>
        </http>
        <other-applications>
          <irc>yes</irc>
        </other-applications>
        <unknown-applications>
          <unknown-tcp>
            <destinations-per-hour>10</destinations-per-hour>
            <sessions-per-hour>10</sessions-per-hour>
            <session-length>
              <maximum-bytes>100</maximum-bytes>
              <minimum-bytes>50</minimum-bytes>
            </session-length>
          </unknown-tcp>
          <unknown-udp>
            <destinations-per-hour>10</destinations-per-hour>
            <sessions-per-hour>10</sessions-per-hour>
            <session-length>
              <maximum-bytes>100</maximum-bytes>
              <minimum-bytes>50</minimum-bytes>
            </session-length>
          </unknown-udp>
        </unknown-applications>
      </configuration>
      <report>
        <topn>100</topn>
        <scheduled>yes</scheduled>
      </report>
    </botnet>
  </shared>
  <devices>
    <entry name="localhost.localdomain">
      <network>
        <interface>
          <ethernet>
            <entry name="ethernet1/5">
              <layer3>
                <ndp-proxy>
                  <enabled>no</enabled>
                </ndp-proxy>
                <ip>
                  <entry name="${var.IPAddressPrefix}.5.254/24"/>
                </ip>
                <lldp>
                  <enable>no</enable>
                </lldp>
              </layer3>
            </entry>
          </ethernet>
        </interface>
        <profiles>
          <monitor-profile>
            <entry name="default">
              <interval>3</interval>
              <threshold>5</threshold>
              <action>wait-recover</action>
            </entry>
          </monitor-profile>
        </profiles>
        <ike>
          <crypto-profiles>
            <ike-crypto-profiles>
              <entry name="default">
                <encryption>
                  <member>aes-128-cbc</member>
                  <member>3des</member>
                </encryption>
                <hash>
                  <member>sha1</member>
                </hash>
                <dh-group>
                  <member>group2</member>
                </dh-group>
                <lifetime>
                  <hours>8</hours>
                </lifetime>
              </entry>
              <entry name="Suite-B-GCM-128">
                <encryption>
                  <member>aes-128-cbc</member>
                </encryption>
                <hash>
                  <member>sha256</member>
                </hash>
                <dh-group>
                  <member>group19</member>
                </dh-group>
                <lifetime>
                  <hours>8</hours>
                </lifetime>
              </entry>
              <entry name="Suite-B-GCM-256">
                <encryption>
                  <member>aes-256-cbc</member>
                </encryption>
                <hash>
                  <member>sha384</member>
                </hash>
                <dh-group>
                  <member>group20</member>
                </dh-group>
                <lifetime>
                  <hours>8</hours>
                </lifetime>
              </entry>
            </ike-crypto-profiles>
            <ipsec-crypto-profiles>
              <entry name="default">
                <esp>
                  <encryption>
                    <member>aes-128-cbc</member>
                    <member>3des</member>
                  </encryption>
                  <authentication>
                    <member>sha1</member>
                  </authentication>
                </esp>
                <dh-group>group2</dh-group>
                <lifetime>
                  <hours>1</hours>
                </lifetime>
              </entry>
              <entry name="Suite-B-GCM-128">
                <esp>
                  <encryption>
                    <member>aes-128-gcm</member>
                  </encryption>
                  <authentication>
                    <member>none</member>
                  </authentication>
                </esp>
                <dh-group>group19</dh-group>
                <lifetime>
                  <hours>1</hours>
                </lifetime>
              </entry>
              <entry name="Suite-B-GCM-256">
                <esp>
                  <encryption>
                    <member>aes-256-gcm</member>
                  </encryption>
                  <authentication>
                    <member>none</member>
                  </authentication>
                </esp>
                <dh-group>group20</dh-group>
                <lifetime>
                  <hours>1</hours>
                </lifetime>
              </entry>
            </ipsec-crypto-profiles>
            <global-protect-app-crypto-profiles>
              <entry name="default">
                <encryption>
                  <member>aes-128-cbc</member>
                </encryption>
                <authentication>
                  <member>sha1</member>
                </authentication>
              </entry>
            </global-protect-app-crypto-profiles>
          </crypto-profiles>
        </ike>
        <qos>
          <profile>
            <entry name="default">
              <class-bandwidth-type>
                <mbps>
                  <class>
                    <entry name="class1">
                      <priority>real-time</priority>
                    </entry>
                    <entry name="class2">
                      <priority>high</priority>
                    </entry>
                    <entry name="class3">
                      <priority>high</priority>
                    </entry>
                    <entry name="class4">
                      <priority>medium</priority>
                    </entry>
                    <entry name="class5">
                      <priority>medium</priority>
                    </entry>
                    <entry name="class6">
                      <priority>low</priority>
                    </entry>
                    <entry name="class7">
                      <priority>low</priority>
                    </entry>
                    <entry name="class8">
                      <priority>low</priority>
                    </entry>
                  </class>
                </mbps>
              </class-bandwidth-type>
            </entry>
          </profile>
        </qos>
        <virtual-router>
          <entry name="default">
            <protocol>
              <bgp>
                <enable>no</enable>
                <dampening-profile>
                  <entry name="default">
                    <cutoff>1.25</cutoff>
                    <reuse>0.5</reuse>
                    <max-hold-time>900</max-hold-time>
                    <decay-half-life-reachable>300</decay-half-life-reachable>
                    <decay-half-life-unreachable>900</decay-half-life-unreachable>
                    <enable>yes</enable>
                  </entry>
                </dampening-profile>
              </bgp>
            </protocol>
          </entry>
        </virtual-router>
      </network>
      <deviceconfig>
        <system>
          <type>
            <dhcp-client>
              <send-hostname>yes</send-hostname>
              <send-client-id>no</send-client-id>
              <accept-dhcp-hostname>no</accept-dhcp-hostname>
              <accept-dhcp-domain>no</accept-dhcp-domain>
            </dhcp-client>
          </type>
          <update-server>updates.paloaltonetworks.com</update-server>
          <update-schedule>
            <threats>
              <recurring>
                <weekly>
                  <day-of-week>wednesday</day-of-week>
                  <at>01:02</at>
                  <action>download-only</action>
                </weekly>
              </recurring>
            </threats>
          </update-schedule>
          <timezone>US/Pacific</timezone>
          <service>
            <disable-telnet>yes</disable-telnet>
            <disable-http>yes</disable-http>
          </service>
          <hostname>shazfr2pafw1</hostname>
          <panorama>
            <local-panorama>
              <panorama-server>10.2.2.1</panorama-server>
            </local-panorama>
          </panorama>
          <route>
            <service>
              <entry name="deployments">
                <source>
                  <address>${var.IPAddressPrefix}.5.254/24</address>
                  <interface>ethernet1/5</interface>
                </source>
              </entry>
              <entry name="dns">
                <source>
                  <address>${var.IPAddressPrefix}.5.254/24</address>
                  <interface>ethernet1/5</interface>
                </source>
              </entry>
              <entry name="ldap">
                <source>
                  <address>${var.IPAddressPrefix}.5.254/24</address>
                  <interface>ethernet1/5</interface>
                </source>
              </entry>
              <entry name="ntp">
                <source>
                  <address>${var.IPAddressPrefix}.5.254/24</address>
                  <interface>ethernet1/5</interface>
                </source>
              </entry>
              <entry name="paloalto-networks-services">
                <source>
                  <address>${var.IPAddressPrefix}.5.254/24</address>
                  <interface>ethernet1/5</interface>
                </source>
              </entry>
              <entry name="panorama">
                <source>
                  <address>${var.IPAddressPrefix}.5.254/24</address>
                  <interface>ethernet1/5</interface>
                </source>
              </entry>
              <entry name="uid-agent">
                <source>
                  <address>${var.IPAddressPrefix}.5.254/24</address>
                  <interface>ethernet1/5</interface>
                </source>
              </entry>
            </service>
          </route>
        </system>
        <setting>
          <config>
            <rematch>yes</rematch>
          </config>
          <management>
            <hostname-type-in-syslog>FQDN</hostname-type-in-syslog>
            <initcfg>
              <type>
                <dhcp-client>
                  <send-hostname>yes</send-hostname>
                  <send-client-id>no</send-client-id>
                  <accept-dhcp-hostname>no</accept-dhcp-hostname>
                  <accept-dhcp-domain>no</accept-dhcp-domain>
                </dhcp-client>
              </type>
              <hostname>shazfr2pafw1</hostname>
              <username>windu</username>
            </initcfg>
          </management>
        </setting>
      </deviceconfig>
      <vsys>
        <entry name="vsys1">
          <application/>
          <application-group/>
          <zone/>
          <service/>
          <service-group/>
          <schedule/>
          <rulebase/>
          <import>
            <network>
              <interface>
                <member>ethernet1/5</member>
              </interface>
            </network>
          </import>
        </entry>
      </vsys>
    </entry>
  </devices>
</config>
EOT
  filename = "${path.module}/bootstrap.xml"
}

# Uploading bootstrap.xml
resource "azurerm_storage_share_file" "bootstrap" {
  name             = "bootstrap.xml"
  storage_share_id = data.azurerm_storage_share.bootstrap-storage-share.id
  source           = "${path.module}/bootstrap.xml"
  path             = "config"
  depends_on       = [local_file.bootstrap]
}

# Generating init-cfg.txt
resource "local_file" "init-cfg" {
  content  = <<EOT
type=dhcp-client
ip-address=
default-gateway=
netmask=
vm-auth-key=${var.panorama_vm_authkey}
panorama-server=${var.panorama}
EOT
  filename = "${path.module}/init-cfg.txt"
}

# Uploading init-cfg.txt
resource "azurerm_storage_share_file" "init-cfg" {
  name             = "init-cfg.txt"
  storage_share_id = data.azurerm_storage_share.bootstrap-storage-share.id
  source           = "${path.module}/init-cfg.txt"
  path             = "config"
  depends_on       = [local_file.bootstrap]
}