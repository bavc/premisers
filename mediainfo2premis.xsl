<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mt="http://www.iana.org/assignments/media-types/" xmlns:la="http://www.loc.gov/standards/iso639-2/" xmlns:str="http://exslt.org/strings" xmlns="info:lc/xmlns/premis-v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" extension-element-prefixes="str">
	<xsl:output encoding="UTF-8" method="xml" version="1.0" indent="yes"/>
	<xsl:template match="Mediainfo">
		<premis>
			<xsl:attribute name="version">
				<xsl:text>2.1</xsl:text>
			</xsl:attribute>
			<object>
				<xsl:attribute name="xsi:type">
					<xsl:text>representation</xsl:text>
				</xsl:attribute>
				<objectIdentifier>
					<objectIdentifierType>
						<xsl:text>Repository Package ID</xsl:text>
					</objectIdentifierType>
					<objectIdentifierValue>
						<xsl:choose>
							<xsl:when test="string-length($representation_objectIdentifierValue)&gt;0">
								<xsl:value-of select="$representation_objectIdentifierValue"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="File[1]/track[@type='General']/FolderName"/>
							</xsl:otherwise>
						</xsl:choose>
					</objectIdentifierValue>
				</objectIdentifier>
				<xsl:for-each select="File">
					<relationship>
						<relationshipType>structural</relationshipType>
						<relationshipSubType>includes</relationshipSubType>
						<relatedObjectIdentification>
							<relatedObjectIdentifierType>
								<xsl:text>URI</xsl:text>
							</relatedObjectIdentifierType>
							<relatedObjectIdentifierValue>
								<xsl:value-of select="track[@type='General']/CompleteName"/>
							</relatedObjectIdentifierValue>
						</relatedObjectIdentification>
					</relationship>
				</xsl:for-each>
			</object>
			<!-- file level objects -->
			<xsl:for-each select="File">
				<xsl:for-each select="track[@type='General']">
					<object>
						<xsl:attribute name="xsi:type">
							<xsl:text>file</xsl:text>
						</xsl:attribute>
						<objectIdentifier>
							<objectIdentifierType>
								<xsl:text>URI</xsl:text>
							</objectIdentifierType>
							<objectIdentifierValue>
								<xsl:value-of select="CompleteName"/>
							</objectIdentifierValue>
						</objectIdentifier>
						<xsl:for-each select="str:tokenize(Media_UUID, '/')">
							<objectIdentifier>
								<objectIdentifierType>Final Cut Studio UUID</objectIdentifierType>
								<objectIdentifierValue>
									<xsl:value-of select="normalize-space(.)"/>
								</objectIdentifierValue>
							</objectIdentifier>
						</xsl:for-each>
						<objectCharacteristics>
							<compositionLevel>0</compositionLevel>
							<size>
								<xsl:value-of select="FileSize"/>
							</size>
							<format>
								<formatDesignation>
									<formatName>
										<xsl:value-of select="Format"/>
									</formatName>
									<formatVersion>
										<xsl:choose>
											<xsl:when test="string-length(Format_Version)&gt;0">
												<xsl:value-of select="Format_Version"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="Format_Profile"/>
											</xsl:otherwise>
										</xsl:choose>
									</formatVersion>
								</formatDesignation>
								<xsl:if test="string-length(CodecID_Url)&gt;0 and string-length(CodecID)&gt;0">
									<formatRegistry>
										<formatRegistryName>
											<xsl:value-of select="CodecID_Url"/>
										</formatRegistryName>
										<formatRegistryKey>
											<xsl:value-of select="CodecID"/>
										</formatRegistryKey>
										<!--<formatRegistryRole></formatRegistryRole>-->
									</formatRegistry>
								</xsl:if>
								<formatNote>
									<xsl:variable name="formatNote">
										<xsl:if test="Format_Commercial_IfAny">
											<xsl:value-of select="Format_Commercial_IfAny"/>
										</xsl:if>
										<xsl:if test="Format_Settings_Endianness">
											<xsl:text> </xsl:text>
											<xsl:value-of select="Format_Settings_Endianness"/>
											<xsl:text>-endian</xsl:text>
										</xsl:if>
										<xsl:if test="Format_Settings_Sign">
											<xsl:text> </xsl:text>
											<xsl:value-of select="Format_Settings_Sign"/>
										</xsl:if>
										<xsl:if test="CodecID and CodecID!=Format">
											<xsl:text> </xsl:text>
											<xsl:value-of select="CodecID"/>
										</xsl:if>
									</xsl:variable>
									<xsl:value-of select="normalize-space($formatNote)"/>
								</formatNote>
							</format>
							<creatingApplication>
								<creatingApplicationName>
									<xsl:value-of select="Encoded_Library_Name"/>
								</creatingApplicationName>
								<creatingApplicationVersion>
									<xsl:value-of select="Encoded_Library_Version"/>
								</creatingApplicationVersion>
								<xsl:if test="string-length(Encoded_Date)&gt;0">
									<dateCreatedByApplication>
										<xsl:choose>
											<xsl:when test="substring(Encoded_Date,1,3)='UTC' and string-length(Encoded_Date)='23'">
												<xsl:value-of select="substring(Encoded_Date,5,10)"/>
												<xsl:text>T</xsl:text>
												<xsl:value-of select="substring(Encoded_Date,16,8)"/>
												<xsl:text>Z</xsl:text>
											</xsl:when>
											<xsl:when test="string-length(Encoded_Date)='19'">
												<xsl:value-of select="substring(Encoded_Date,1,10)"/>
												<xsl:text>T</xsl:text>
												<xsl:value-of select="substring(Encoded_Date,12,8)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="Encoded_Date"/>
											</xsl:otherwise>
										</xsl:choose>
									</dateCreatedByApplication>
								</xsl:if>
								<creatingApplicationExtension/>
							</creatingApplication>
						</objectCharacteristics>
						<environment>
							<environmentCharacteristic/>
							<environmentPurpose/>
							<environmentNote/>
							<!--
										<dependancy>
												<dependancyName></dependancyName>
												<dependencyIdentifier>
														<dependencyIdentifierType></dependencyIdentifierType>
														<dependencyIdentifierValue></dependencyIdentifierValue>
												</dependencyIdentifier>
										</dependancy>
										-->
							<!--
														<software>
																<swName><xsl:value-of select="document('test_excel_as_xml.xsl')/e:Workbook/e:Worksheet/e:Table/e:Row[2]/e:Cell[2]/e:Data"/></swName>
																<swVersion></swVersion>
																<swType></swType>
																<swOtherInformation></swOtherInformation>
																<swDependency></swDependency>
														</software>
														<hardware>
																<hwName></hwName>
																<hwType></hwType>
																<hwOtherInformation></hwOtherInformation>
														</hardware>
														<environmentExtension></environmentExtension>
														-->
						</environment>
						<xsl:for-each select="../track[@type!='General']">
							<relationship>
								<relationshipType>structural</relationshipType>
								<relationshipSubType>includes</relationshipSubType>
								<relatedObjectIdentification>
									<relatedObjectIdentifierType>
										<xsl:text>URI.StreamType.StreamNumber</xsl:text>
									</relatedObjectIdentifierType>
									<relatedObjectIdentifierValue>
										<xsl:value-of select="../track[@type='General']/CompleteName"/>
										<xsl:text>:</xsl:text>
										<xsl:choose>
											<!-- some translation of reported trackType, else reported as is -->
											<xsl:when test="@type='Video'">video</xsl:when>
											<xsl:when test="@type='Audio'">audio</xsl:when>
											<xsl:when test="Format='TimeCode'">timecode</xsl:when>
											<xsl:when test="Format='EIA-608' or Format='EIA-708'">caption</xsl:when>
											<xsl:when test="Format='Apple text|ASS|DivX Subtitle|DVB Subtitles|PGS|SSA|Teletext|Text|Subrip|SubRip|Timed text|USF|VobSub'">subtitle</xsl:when>
											<xsl:when test="Format='CMML'">metadata</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="@type"/>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:text>:</xsl:text>
										<xsl:value-of select="StreamKindID"/>
									</relatedObjectIdentifierValue>
								</relatedObjectIdentification>
							</relationship>
						</xsl:for-each>
					</object>
				</xsl:for-each>
				<!-- track level data as bitstream -->
				<xsl:for-each select="track[@type!='General']">
					<object>
						<xsl:attribute name="xsi:type">
							<xsl:text>bitstream</xsl:text>
						</xsl:attribute>
						<objectIdentifier>
							<objectIdentifierType>
								<xsl:text>URI.StreamType.StreamNumber</xsl:text>
							</objectIdentifierType>
							<objectIdentifierValue>
								<xsl:value-of select="../track[@type='General']/CompleteName"/>
								<xsl:text>:</xsl:text>
								<xsl:choose>
									<!-- some translation of reported trackType, else reported as is -->
									<xsl:when test="@type='Video'">video</xsl:when>
									<xsl:when test="@type='Audio'">audio</xsl:when>
									<xsl:when test="Format='TimeCode'">timecode</xsl:when>
									<xsl:when test="Format='EIA-608' or Format='EIA-708'">caption</xsl:when>
									<xsl:when test="Format='Apple text|ASS|DivX Subtitle|DVB Subtitles|PGS|SSA|Teletext|Text|Subrip|SubRip|Timed text|USF|VobSub'">subtitle</xsl:when>
									<xsl:when test="Format='CMML'">metadata</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@type"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:text>:</xsl:text>
								<xsl:value-of select="StreamKindID"/>
							</objectIdentifierValue>
						</objectIdentifier>
						<objectCharacteristics>
							<compositionLevel>0</compositionLevel>
							<size>
								<xsl:value-of select="StreamSize"/>
							</size>
							<format>
								<formatDesignation>
									<formatName>
										<xsl:value-of select="Format"/>
										<xsl:if test="Format_Profile">
											<xsl:text> </xsl:text>
											<xsl:value-of select="Format_Profile"/>
										</xsl:if>
									</formatName>
									<formatVersion>
										<xsl:value-of select="Format_Version"/>
									</formatVersion>
								</formatDesignation>
								<xsl:if test="string-length(CodecID_Url)&gt;0 and string-length(CodecID)&gt;0">
									<formatRegistry>
										<formatRegistryName>
											<xsl:value-of select="CodecID_Url"/>
										</formatRegistryName>
										<formatRegistryKey>
											<xsl:value-of select="CodecID"/>
										</formatRegistryKey>
										<!--<formatRegistryRole></formatRegistryRole>-->
									</formatRegistry>
								</xsl:if>
								<formatNote>
									<xsl:variable name="formatNote">
										<xsl:if test="Format_Commercial_IfAny">
											<xsl:value-of select="Format_Commercial_IfAny"/>
										</xsl:if>
										<xsl:if test="Format_Settings_Endianness">
											<xsl:text> </xsl:text>
											<xsl:value-of select="Format_Settings_Endianness"/>
											<xsl:text>-endian</xsl:text>
										</xsl:if>
										<xsl:if test="Format_Settings_Sign">
											<xsl:text> </xsl:text>
											<xsl:value-of select="Format_Settings_Sign"/>
										</xsl:if>
										<xsl:if test="CodecID and CodecID!=Format">
											<xsl:text> </xsl:text>
											<xsl:value-of select="CodecID"/>
										</xsl:if>
									</xsl:variable>
									<xsl:value-of select="normalize-space($formatNote)"/>
								</formatNote>
							</format>
							<creatingApplication>
								<creatingApplicationName>
									<xsl:value-of select="Encoded_Library_Name"/>
								</creatingApplicationName>
								<creatingApplicationVersion>
									<xsl:value-of select="Encoded_Library_Version"/>
								</creatingApplicationVersion>
								<xsl:if test="string-length(Encoded_Date)&gt;0">
									<dateCreatedByApplication>
										<xsl:choose>
											<xsl:when test="substring(Encoded_Date,1,3)='UTC' and string-length(Encoded_Date)='23'">
												<xsl:value-of select="substring(Encoded_Date,5,10)"/>
												<xsl:text>T</xsl:text>
												<xsl:value-of select="substring(Encoded_Date,16,8)"/>
												<xsl:text>Z</xsl:text>
											</xsl:when>
											<xsl:when test="string-length(Encoded_Date)='19'">
												<xsl:value-of select="substring(Encoded_Date,1,10)"/>
												<xsl:text>T</xsl:text>
												<xsl:value-of select="substring(Encoded_Date,12,8)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="Encoded_Date"/>
											</xsl:otherwise>
										</xsl:choose>
									</dateCreatedByApplication>
								</xsl:if>
								<creatingApplicationExtension/>
							</creatingApplication>
						</objectCharacteristics>
						<relationship>
							<relationshipType>structural</relationshipType>
							<relationshipSubType>is included in</relationshipSubType>
							<relatedObjectIdentification>
								<relatedObjectIdentifierType>
									<xsl:text>URI.StreamType.StreamNumber</xsl:text>
								</relatedObjectIdentifierType>
								<relatedObjectIdentifierValue>
									<xsl:value-of select="../track[@type='General']/CompleteName"/>
								</relatedObjectIdentifierValue>
							</relatedObjectIdentification>
						</relationship>
					</object>
				</xsl:for-each>
			</xsl:for-each>
		</premis>
	</xsl:template>
</xsl:stylesheet>