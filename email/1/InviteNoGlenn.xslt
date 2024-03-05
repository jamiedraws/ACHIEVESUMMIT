<xsl:stylesheet
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
version="2.0" xmlns:ms="urn:schemas-microsoft-com:xslt">
  <xsl:template name="string-replace-all">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="by" />
    <xsl:choose>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text,$replace)" />
        <xsl:value-of select="$by" />
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text" select="substring-after($text,$replace)" />
          <xsl:with-param name="replace" select="$replace" />
          <xsl:with-param name="by" select="$by" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:output method="html" />
  <xsl:template match="/Lead">
    <html>
      <head>
        <title>You're invited!</title>
      </head>
      <body>
        <table width="550" border="0" cellpadding="8" cellspacing="1">
          <tr>
            <td bgcolor="#FFFFFF" style="line-height: 1.5;font:14px Arial, Helvetica, sans-serif;">
              <p>
                <b>
                  Hi <xsl:value-of select="LeadFirstName"/>&#160;<xsl:value-of select ="LeadLastName"/>!
                </b>
              </p>
              <p>
                <xsl:value-of select="FirstName"/>&#160;<xsl:value-of select ="LastName"/> will be attending the Wealth &amp; Achievement Summit and thinks you would like to join them.
              </p>
              <tr style="padding: 0; border: none;">
                <td align="center" style="color:#ffffff; font:bold 13px Arial, Helvetica, sans-serif; padding:0; border: none; text-align: center;">
                  <a href="{ReferredTo}">
                    <img src="{Domain}/images/email/1/invite-email-no-glenn.png" alt="Wealth &amp; Achievement Summit"/>
                 </a>
                </td>
              </tr>
              <div style="background: #f9f9f9; color: #1c7f38; line-height: 1.5; padding: 10px; font-size: 15px;">
                  <p style="border-bottom: 2px solid #ccc;padding-bottom: 10px;font-weight: bold;text-transform: uppercase;color: #333;">Event Details:</p>
                  <p>
                    <strong>
                      <xsl:value-of select="Seminar/Location" disable-output-escaping="yes"/>
                      <br />
                      <xsl:value-of select="ms:format-date(Seminar/Date, 'MMM dd, yyyy')"/>
                      <br />
                      <xsl:value-of select="Seminar/Time"/>
                      <br />
                    </strong>
                  </p>
                </div>
                <img src="{Domain}/images/email/seating-banner.png" alt="SPECIAL SEATING AREAS for social distancing will be available for all attendees."/>
              <p>
                <a href="{ReferredTo}">Click Here to register and secure your seat at the same event.</a>
              </p>
            </td>
          </tr>
        </table>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
