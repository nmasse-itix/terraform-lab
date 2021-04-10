<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output omit-xml-declaration="yes" indent="yes"/>

  <!-- XSLT Identity template -->
  <xsl:template match="node()|@*">
     <xsl:copy>
       <xsl:apply-templates select="node()|@*"/>
     </xsl:copy>
  </xsl:template>

  <!-- Change the NIC model to e1000e -->
  <xsl:template match="/domain/devices/interface[@type='network']/model/@type">
    <xsl:attribute name="type">
      <xsl:value-of select="'e1000e'"/>
    </xsl:attribute>
  </xsl:template>

  <!-- Change all disks to SATA and renumber them (sda, sdb, etc.)-->
  <xsl:template match="/domain/devices">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()[not(ancestor-or-self::disk)]"/>
      <xsl:for-each select="disk">
        <disk>
          <xsl:apply-templates select="@*|node()[not(ancestor-or-self::target | ancestor-or-self::wwn)]"/>
          <target bus="sata" rotation_rate="1">
            <xsl:attribute name="rotation_rate">
              <!-- Disk is an SSD -->
              <xsl:value-of select="'1'" />
              <!-- Disk is an HDD (7200 RPM) -->
              <!-- <xsl:value-of select="'7200'" /> -->
            </xsl:attribute>
            <xsl:attribute name="dev">
              <xsl:value-of select="'sd'" /><xsl:number value="position()" format="a"/>
            </xsl:attribute>
          </target>
        </disk>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <!-- Hide KVM for the guest -->
  <xsl:template match="/*">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <features>
        <kvm>
          <hidden state='on'/>
        </kvm>
      </features>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>