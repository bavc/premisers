<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="info:lc/xmlns/premis-v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ffprobe="http://www.ffmpeg.org/schema/ffprobe" version="1.0">
	<xsl:output encoding="UTF-8" method="xml" version="1.0" indent="yes"/>
	<xsl:template match="ffprobe:ffprobe">
		<premis>
			<xsl:attribute name="version">
				<xsl:text>2.2</xsl:text>
			</xsl:attribute>
			<object>
				<xsl:attribute name="xsi:type">
					<xsl:text>file</xsl:text>
				</xsl:attribute>
				<objectIdentifier>
					<objectIdentifierType>
						<xsl:text>URI</xsl:text>
					</objectIdentifierType>
					<objectIdentifierValue>
						<xsl:value-of select="format/@filename"/>
					</objectIdentifierValue>
				</objectIdentifier>
				<objectCharacteristics>
					<!-- This is required, but I do not choose to determine it. Using zero because I have to put something. -->
					<compositionLevel>0</compositionLevel>
					<size>
						<xsl:value-of select="format/@size"/>
					</size>
					<format>
						<formatDesignation>
							<formatName>
								<xsl:value-of select="format/@format_long_name"/>
							</formatName>
						</formatDesignation>
					</format>
					<creatingApplication>
						<creatingApplicationName>
							<xsl:value-of select="format/tag[@key='encoder']/@value"/>
						</creatingApplicationName>
					</creatingApplication>
				</objectCharacteristics>
				<!-- @filename, @size and @format_long_name are mapped elsewhere, map all the rest to significant properties -->
				<xsl:for-each select="format/@*[local-name() != 'filename' and local-name() != 'size' and local-name() != 'format_long_name']">
					<significantProperties>
						<significantPropertiesType>
							<xsl:value-of select="name(.)"/>
						</significantPropertiesType>
						<significantPropertiesValue>
							<xsl:value-of select="."/>
						</significantPropertiesValue>
					</significantProperties>
				</xsl:for-each>
				<!-- the encoder tag is already mapped, so just take the rest -->
				<xsl:for-each select="format/tag[@key != 'encoder']">
					<significantProperties>
						<significantPropertiesType>
							<xsl:value-of select="@key"/>
						</significantPropertiesType>
						<significantPropertiesValue>
							<xsl:value-of select="@value"/>
						</significantPropertiesValue>
					</significantProperties>
				</xsl:for-each>
				<xsl:for-each select="streams/stream">
					<relationship>
						<relationshipType>structural</relationshipType>
						<relationshipSubType>includes</relationshipSubType>
						<relatedObjectIdentification>
							<relatedObjectIdentifierType>
								<xsl:text>ffmpeg:stream_index</xsl:text>
							</relatedObjectIdentifierType>
							<relatedObjectIdentifierValue>
								<xsl:value-of select="@index"/>
							</relatedObjectIdentifierValue>
						</relatedObjectIdentification>
					</relationship>
				</xsl:for-each>
			</object>
			<!-- track level data as bitstream -->
			<xsl:for-each select="streams/stream">
				<object>
					<xsl:attribute name="xsi:type">
						<xsl:text>bitstream</xsl:text>
					</xsl:attribute>
					<objectIdentifier>
						<objectIdentifierType>
							<xsl:text>ffmpeg:stream_index</xsl:text>
						</objectIdentifierType>
						<objectIdentifierValue>
							<xsl:value-of select="@index"/>
						</objectIdentifierValue>
					</objectIdentifier>
					<objectCharacteristics>
						<!-- This is required, but I do not choose to determine it. Using zero because I have to put something. :-/	-->
						<compositionLevel>0</compositionLevel>
						<format>
							<formatDesignation>
								<xsl:if test="@codec_long_name">
									<formatName>
										<xsl:value-of select="@codec_long_name"/>
									</formatName>
								</xsl:if>
								<xsl:if test="@profile">
									<formatVersion>
										<xsl:value-of select="@profile"/>
									</formatVersion>
								</xsl:if>
							</formatDesignation>
						</format>
					</objectCharacteristics>
					<!-- @codec_long_name and @profile are mapped elsewhere, map all the rest to significant properties -->
					<xsl:for-each select="@*[local-name() != 'codec_long_name' and local-name() != 'profile']">
						<significantProperties>
							<significantPropertiesType>
								<xsl:value-of select="name(.)"/>
							</significantPropertiesType>
							<significantPropertiesValue>
								<xsl:value-of select="."/>
							</significantPropertiesValue>
						</significantProperties>
					</xsl:for-each>
					<xsl:for-each select="tag">
						<significantProperties>
							<significantPropertiesType>
								<xsl:value-of select="@key"/>
							</significantPropertiesType>
							<significantPropertiesValue>
								<xsl:value-of select="@value"/>
							</significantPropertiesValue>
						</significantProperties>
					</xsl:for-each>
					<relationship>
						<relationshipType>structural</relationshipType>
						<relationshipSubType>is included in</relationshipSubType>
						<relatedObjectIdentification>
							<relatedObjectIdentifierType>
								<xsl:text>URI</xsl:text>
							</relatedObjectIdentifierType>
							<relatedObjectIdentifierValue>
								<xsl:value-of select="../../format/@filename"/>
							</relatedObjectIdentifierValue>
						</relatedObjectIdentification>
					</relationship>
				</object>
			</xsl:for-each>
		</premis>
	</xsl:template>
</xsl:stylesheet>
