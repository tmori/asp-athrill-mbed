#!ruby -Ke
#
#  TTG
#      TOPPERS Test Generator
#
#  Copyright (C) 2009-2012 by Center for Embedded Computing Systems
#              Graduate School of Information Science, Nagoya Univ., JAPAN
#  Copyright (C) 2010-2011 by Graduate School of Information Science,
#                             Aichi Prefectural Univ., JAPAN
#  Copyright (C) 2012 by FUJISOFT INCORPORATED
#
#  �嵭����Ԥϡ��ʲ���(1)��(4)�ξ������������˸¤ꡤ�ܥ��եȥ���
#  �����ܥ��եȥ���������Ѥ�����Τ�ޤࡥ�ʲ�Ʊ���ˤ���ѡ�ʣ������
#  �ѡ������ۡʰʲ������ѤȸƤ֡ˤ��뤳�Ȥ�̵���ǵ������롥
#  (1) �ܥ��եȥ������򥽡��������ɤη������Ѥ�����ˤϡ��嵭������
#      ��ɽ�����������Ѿ�浪��Ӳ�����̵�ݾڵ��꤬�����Τޤޤη��ǥ���
#      ����������˴ޤޤ�Ƥ��뤳�ȡ�
#  (2) �ܥ��եȥ������򡤥饤�֥������ʤɡ�¾�Υ��եȥ�������ȯ�˻�
#      �ѤǤ�����Ǻ����ۤ�����ˤϡ������ۤ�ȼ���ɥ�����ȡ�����
#      �ԥޥ˥奢��ʤɡˤˡ��嵭�����ɽ�����������Ѿ�浪��Ӳ���
#      ��̵�ݾڵ����Ǻܤ��뤳�ȡ�
#  (3) �ܥ��եȥ������򡤵�����Ȥ߹���ʤɡ�¾�Υ��եȥ�������ȯ�˻�
#      �ѤǤ��ʤ����Ǻ����ۤ�����ˤϡ����Τ����줫�ξ�����������
#      �ȡ�
#    (a) �����ۤ�ȼ���ɥ�����ȡ����Ѽԥޥ˥奢��ʤɡˤˡ��嵭����
#        �ɽ�����������Ѿ�浪��Ӳ�����̵�ݾڵ����Ǻܤ��뤳�ȡ�
#    (b) �����ۤη��֤��̤�������ˡ�ˤ�äơ�TOPPERS�ץ������Ȥ�
#        ��𤹤뤳�ȡ�
#  (4) �ܥ��եȥ����������Ѥˤ��ľ��Ū�ޤ��ϴ���Ū�������뤤���ʤ�»
#      ������⡤�嵭����Ԥ����TOPPERS�ץ������Ȥ����դ��뤳�ȡ�
#      �ޤ����ܥ��եȥ������Υ桼���ޤ��ϥ���ɥ桼������Τ����ʤ���
#      ͳ�˴�Ť����ᤫ��⡤�嵭����Ԥ����TOPPERS�ץ������Ȥ�
#      ���դ��뤳�ȡ�
#
#  �ܥ��եȥ������ϡ�̵�ݾڤ��󶡤���Ƥ����ΤǤ��롥�嵭����Ԥ�
#  ���TOPPERS�ץ������Ȥϡ��ܥ��եȥ������˴ؤ��ơ�����λ�����Ū
#  ���Ф���Ŭ������ޤ�ơ������ʤ��ݾڤ�Ԥ�ʤ����ޤ����ܥ��եȥ���
#  �������Ѥˤ��ľ��Ū�ޤ��ϴ���Ū�������������ʤ�»���˴ؤ��Ƥ⡤��
#  ����Ǥ�����ʤ���
#
#  $Id: ProcessUnit.rb 6 2012-09-03 11:06:01Z nces-shigihara $
#
require "ttc/bin/class/TTCCommon.rb"

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: ProcessUnit
  # ��    ��: ����ñ�̥��֥������Ȥξ����������륯�饹
  #===================================================================
  class ProcessUnit
    include TTCModule
    include TTCModule::ObjectCommon

    #=================================================================
    # ������: °�������å�(����°������ꤷ����������å�)
    #=================================================================
    def pre_attribute_check(hObjectInfo, aPath, bIsPre)
      check_class(Hash, hObjectInfo)  # ���֥������Ⱦ���
      check_class(Array, aPath)       # �롼�Ȥ���Υѥ�
      check_class(Bool, bIsPre)       # pre_condition�⤫

      aErrors = []
      begin
        super(hObjectInfo, aPath, bIsPre)
      rescue TTCMultiError
        aErrors.concat($!.aErrors)
      end

      # do
      if (hObjectInfo[TSR_PRM_DO].is_a?(Hash))
        aAtrDefList = get_do_attribute_list().keys()
        aAtrDefList.delete(TSR_PRM_ID)  # id°��������Ǥ��ʤ��ΤǺ��
        begin
          check_defined_attribute(hObjectInfo[TSR_PRM_DO].keys(), aAtrDefList, aPath + [TSR_PRM_DO])
        rescue TTCMultiError
          aErrors.concat($!.aErrors)
        end
      end

      # var
      if (hObjectInfo[TSR_PRM_VAR].is_a?(Hash))
        hObjectInfo[TSR_PRM_VAR].each{|sVarName, hVar|
          if (hVar.is_a?(Hash))
            ### T1_025: pre_condition���ѿ���type�����ꤵ��Ƥ��ʤ�
            if (bIsPre == true && hVar[TSR_PRM_VAR_TYPE].nil?())
              sErr = sprintf("T1_025: " + ERR_REQUIRED_KEY, TSR_PRM_VAR_TYPE)
              aErrors.push(YamlError.new(sErr, aPath + [TSR_PRM_VAR, sVarName]))
            ### T1_026: post_condition���ѿ���type�����ꤵ��Ƥ���
            elsif (bIsPre == false && hVar.has_key?(TSR_PRM_VAR_TYPE))
              sErr = sprintf("T1_026: " + ERR_ONLY_PRE_ATR, TSR_PRM_VAR_TYPE)
              aErrors.push(YamlError.new(sErr, aPath + [TSR_PRM_VAR, sVarName]))
            end
          else
            # Variable���饹�Υ��󥹥����ѿ���������������T2_001�����å���»�
            sErr = sprintf("T2_001: " + ERR_INVALID_TYPE, sVarName, "Hash", hVar.class())
            aErrors.push(YamlError.new(sErr, aPath + [TSR_PRM_VAR, sVarName]))
          end
        }
      elsif (hObjectInfo[TSR_PRM_VAR].nil?())
        # ���⤷�ʤ�
      else
        # Variable���饹�Υ��󥹥����ѿ���������������T2_001�����å���»�
        sErr = sprintf("T2_001: " + ERR_INVALID_TYPE, TSR_PRM_VAR, "Hash", hObjectInfo[TSR_PRM_VAR].class())
        aErrors.push(YamlError.new(sErr, aPath))
      end

      check_error(aErrors)
    end

    #=================================================================
    # ��  ��: °�������å�
    #=================================================================
    def attribute_check()
      aErrors = []
      @hState.each{|sAtr, val|
        begin
          sAtr = get_real_attribute_name(sAtr)
          if (is_specified?(sAtr))
            case sAtr
            # 0�ʾ������
            when TSR_PRM_LEFTTMO, TSR_PRM_LEFTTIM, TSR_PRM_EXINF, TSR_PRM_BOOTCNT, TSR_PRM_PORDER,
                 TSR_PRM_CYCPHS, TSR_PRM_CYCTIM, TSR_PRM_PNDPTN, TSR_PRM_TEXPTN
              check_attribute_unsigned(sAtr, val, @aPath)

            # 0����礭������
            when TSR_PRM_PRCID
              check_attribute_gt(sAtr, val, 0, @aPath)

            # ʸ����
            when TSR_PRM_CLASS, TSR_PRM_TASK, TSR_PRM_SPINID
              check_attribute_type(sAtr, val, String, false, @aPath)

            # ʸ����Nil
            when TSR_PRM_WOBJID
              check_attribute_type(sAtr, val, String, true, @aPath)

            # 0�ʾ��������ʸ����
            when TSR_PRM_ACTPRC, TSR_PRM_EXCNO, TSR_PRM_INHNO, TSR_PRM_INTNO
              unless (val.is_a?(String))
                check_attribute_unsigned(sAtr, val, @aPath)
              end

            # 0��꾮����������ʸ����
            when TSR_PRM_INTPRI
              unless (val.is_a?(String))
                check_attribute_lt(sAtr, val, 0, @aPath)
              end

            # ������
            when TSR_PRM_GLOBAL
              check_attribute_type(sAtr, val, Bool, false, @aPath)

            # ͥ����
            when TSR_PRM_ITSKPRI, TSR_PRM_TSKPRI, TSR_PRM_ISRPRI
              check_attribute_range(sAtr, val, TTC_MAX_PRI, TTC_MIN_PRI, @aPath)

            # ��ư���塼����
            when TSR_PRM_ACTCNT, TSR_PRM_WUPCNT
              check_attribute_range(sAtr, val, 0, TTC_MAX_QUEUING, @aPath)

            # do
            when TSR_PRM_DO
              check_attribute_type(sAtr, val, Hash, false, @aPath)
              check_do_attribute(val, @aSpecifiedDoAttributes, @aPath + [sAtr])

            # var
            when TSR_PRM_VAR
              check_attribute_type(sAtr, val, Hash, false, @aPath)
              # �ѿ�̾�Υ����å�
              val.each{|sVarName, cVar|
                check_attribute_variable(sAtr, sVarName, @aPath)
                cVar.check_attribute_value()
              }

            # hdlstat
            when TSR_PRM_HDLSTAT
              if (@cConf.is_asp?())
                aList = GRP_ENUM_HDLSTAT_ASP
              elsif (@cConf.is_fmp?())
                aList = GRP_ENUM_HDLSTAT_FMP
              else
                abort(ERR_MSG % [__FILE__, __LINE__])
              end
              check_attribute_type(sAtr, val, String, false, @aPath)
              check_attribute_enum(sAtr, val, aList, @aPath)

            # state
            when TSR_PRM_TSKSTAT, TSR_PRM_ALMSTAT, TSR_PRM_CYCSTAT, TSR_PRM_TEXSTAT, TSR_PRM_INTSTAT
              # TESRY�Ǥ��ͤ��᤹
              val = get_real_state_value()
              # �����ǽ����
              if (@cConf.is_asp?())
                aList = GRP_OBJECT_STATE_AVAILABLE_ASP
              elsif (@cConf.is_fmp?())
                aList = GRP_OBJECT_STATE_AVAILABLE_FMP
              else
                abort(ERR_MSG % [__FILE__, __LINE__])
              end
              check_attribute_type(sAtr, val, String, false, @aPath)
              check_attribute_enum(sAtr, val, aList[sAtr], @aPath)

            # °��
            when TSR_PRM_CYCATR, TSR_PRM_INTATR
              check_attribute_type(sAtr, val, String, false, @aPath)
              check_attribute_multi(sAtr, val, GRP_AVAILABLE_OBJATR[@sObjectType], @aPath)

            else
              abort(ERR_MSG % [__FILE__, __LINE__])
            end
          end
        rescue TTCError
          aErrors.push($!)
        end
      }

      check_error(aErrors)
    end

    #=================================================================
    # ��  ��: ���֥������ȥ����å�
    #=================================================================
    def object_check(bIsPre = false)
      check_class(Bool, bIsPre)  # pre_condition��

      aErrors = []
      # �ѿ��Υ����å�
      unless (@hState[TSR_PRM_VAR].nil?())
        @hState[TSR_PRM_VAR].each{|sVarName, cVar|
          begin
            cVar.object_check(bIsPre)
          rescue TTCMultiError
            aErrors.concat($!.aErrors)
          end
        }
      end

      # �����Х������Υ����å�
      if (bIsPre == true && (@sObjectType == TSR_OBJ_INIRTN || @sObjectType == TSR_OBJ_TERRTN))
        if (@hState[TSR_PRM_GLOBAL] == true)
          ### T3_INI001: �����Х������롼�����������줿�Ȥ���class�����ꤵ��Ƥ���
          ### T3_TER001: �����Х뽪λ�롼�����������줿�Ȥ���class�����ꤵ��Ƥ���
          if (is_specified?(TSR_PRM_CLASS))
            sErr = sprintf(ERR_ON_GLOBAL_SET_CLASS, @sObjectID)
            if (@sObjectType == TSR_OBJ_INIRTN)
              sErr = "T3_INI001: " + sErr
            else
              sErr = "T3_TER001: " + sErr
            end
            aErrors.push(YamlError.new(sErr, @aPath))
          end
          ### T3_INI002: �����Х������롼�����������줿�Ȥ���prcid�����ꤵ��Ƥ���
          ### T3_TER002: �����Х뽪λ�롼�����������줿�Ȥ���prcid�����ꤵ��Ƥ���
          if (is_specified?(TSR_PRM_PRCID))
            sErr = sprintf(ERR_ON_GLOBAL_SET_PRCID, @sObjectID)
            if (@sObjectType == TSR_OBJ_INIRTN)
              sErr = "T3_INI002: " + sErr
            else
              sErr = "T3_TER002: " + sErr
            end
            aErrors.push(YamlError.new(sErr, @aPath))
          end
        end
      end

      check_error(aErrors)
    end

    #=================================================================
    # ������: ���֥���������Υޥ�����ִ�����
    #=================================================================
    def convert_macro()
      super()

      # �ѿ�
      if (@hState[TSR_PRM_VAR].is_a?(Hash))
        @hState[TSR_PRM_VAR].each_value{|cVar|
          cVar.convert_macro()
        }
      end
    end

    #=================================================================
    # ��  ��: �����Х��б��Τ���ѥ�᡼�����Ѵ���¹Ԥ���
    #=================================================================
    def convert_global(hTable, hClassTable)
      check_class(Hash, hTable)       # �Ѵ�ɽ
      check_class(Hash, hClassTable)  # ���饹�ִ��б�ɽ

      super(hTable, hClassTable)

      # �ѿ�
      unless (@hState[TSR_PRM_VAR].nil?())
        @hState[TSR_PRM_VAR].each_value{|cVar|
          cVar.convert_global(hTable)
        }
      end
    end

    #=================================================================
    # ��  ��: ����ͤ��䴰����
    #=================================================================
    def complement_init_object_info()
      # ���������λ�롼����
      if (@sObjectType == TSR_OBJ_INIRTN || @sObjectType == TSR_OBJ_TERRTN)
        hMacro = @cConf.get_macro()

        # global
        unless (is_specified?(TSR_PRM_GLOBAL))
          @hState[TSR_PRM_GLOBAL] = false
        end
        # exinf
        unless (is_specified?(TSR_PRM_EXINF))
          @hState[TSR_PRM_EXINF] = hMacro["EXINF_A"]
        end
        # gcov
        if (!@aSpecifiedDoAttributes.include?(TSR_PRM_GCOV) &&
            (@aSpecifiedDoAttributes.include?(TSR_PRM_SYSCALL) || @aSpecifiedDoAttributes.include?(TSR_PRM_CODE)))
          @hState[TSR_PRM_DO][TSR_PRM_GCOV] = true
        end
      end

      # fmp����
      if (@cConf.is_fmp?())
        # global�ν�����롼���󡦽�λ�롼����
        if ((@sObjectType == TSR_OBJ_INIRTN || @sObjectType == TSR_OBJ_TERRTN) && @hState[TSR_PRM_GLOBAL] == true)
          # class
          unless (is_specified?(TSR_PRM_CLASS))
            @hState[TSR_PRM_CLASS] = IMC_NO_CLASS
          end
          # prcid
          unless (is_specified?(TSR_PRM_PRCID))
            @hState[TSR_PRM_PRCID] = "MAIN_PRCID"
          end
        else
          # class
          unless (is_specified?(TSR_PRM_CLASS))
            if (@sObjectType == TSR_OBJ_ISR)
              @hState[TSR_PRM_CLASS] = CFG_MCR_CLS_SELF_ONLY_SELF
            else
              @hState[TSR_PRM_CLASS] = CFG_MCR_CLS_SELF_ALL
            end
          end
          # prcid
          unless (is_specified?(TSR_PRM_PRCID))
            @hState[TSR_PRM_PRCID] = CFG_MCR_PRC_SELF
          end
        end
      end
    end

    #=================================================================
    # ������: �䴰��¹Ԥ���
    #=================================================================
    def complement(cPrevObj)
      check_class(ProcessUnit, cPrevObj)  # ľ���ξ��֤Υ��֥�������

      # ���ꤵ��Ƥ��ʤ�����䴰
      cPrevObj.hState.each{|sAtr, val|
        sRealAtr = get_real_attribute_name(sAtr)
        if (!is_specified?(sRealAtr))
          # �ѿ����䴰
          if (sRealAtr == TSR_PRM_VAR && val.is_a?(Hash))
            complement_variable(val)
          else
            @hState[sAtr] = safe_dup(val)
          end
        # �ѿ��ξ�ά���줿°�����䴰
        elsif (sRealAtr == TSR_PRM_VAR && val.is_a?(Hash))
          complement_variable(val)
        end
      }
    end

    #=================================================================
    # ������: �ѿ����䴰��¹Ԥ���
    #=================================================================
    def complement_variable(hPrevVar)
      check_class(Hash, hPrevVar)  # ľ���ξ��֤��ѿ�

      if (@hState[TSR_PRM_VAR].nil?())
        @hState[TSR_PRM_VAR] = {}
      end
      hPrevVar.each{|sVarName, cVar|
        # �ѿ��ξ��󤬾�ά����Ƥ������ʣ��
        if (@hState[TSR_PRM_VAR][sVarName].nil?())
          @hState[TSR_PRM_VAR][sVarName] = cVar.dup()
          @hState[TSR_PRM_VAR][sVarName].aSpecifiedAttributes = []
        # �ѿ��ξ��󤬤�������䴰
        else
          @hState[TSR_PRM_VAR][sVarName].complement(cVar)
        end
      }
    end

    #=================================================================
    # ������: �����ꥢ����¹Ԥ���
    #=================================================================
    def alias(hAlias)
      check_class(Hash, hAlias)   # �����ꥢ���Ѵ��ơ��֥�

      super(hAlias)

      # �ѿ�
      unless (@hState[TSR_PRM_VAR].nil?())
        hTmp = @hState[TSR_PRM_VAR].dup()
        @hState[TSR_PRM_VAR] = {}
        hTmp.each{|sVarName, cVar|
          sAlias = hAlias[sVarName]
          cVar.alias(hAlias)
          @hState[TSR_PRM_VAR][sAlias] = cVar
        }
      end

      # do
      unless (@hState[TSR_PRM_DO].nil?())
        @hState[TSR_PRM_DO].each{|sAtr, val|
          @hState[TSR_PRM_DO][sAtr] = alias_replace(val, hAlias)
        }
      end
    end

    #=================================================================
    # ������: ���֥������ȤΥ����ꥢ���Ѵ��ơ��֥���֤�
    #=================================================================
    def get_alias(sTestID, nNum = nil)
      check_class(String, sTestID)      # �ƥ���ID
      check_class(Integer, nNum, true)  # �����ֹ�

      hResult = {}

      # ���֥�������ID
      case @sObjectType
      # ����ߥϥ�ɥ�ξ�硤��٥�+������ֹ���֤�������
      when TSR_OBJ_INTHDR
        hResult[@sObjectID] = "#{TTG_LBL_INTHDR}_#{@hState[TSR_PRM_INTNO]}"
      # ����ߥ����ӥ��롼����ξ�硤��٥�+������ֹ�+�ƥ���ID+���֥�������ID���֤�������
      when TSR_OBJ_ISR
        hResult[@sObjectID] = "#{TTG_LBL_ISR}_#{@hState[TSR_PRM_INTNO]}_#{alias_str(@sObjectID, sTestID)}"
      # CPU�㳰�ϥ�ɥ�ξ�硤��٥�+CPU�㳰�ϥ�ɥ��ֹ���֤�������
      when TSR_OBJ_EXCEPTION
        hResult[@sObjectID] = "#{TTG_LBL_EXCEPTION}_#{@hState[TSR_PRM_EXCNO]}"
      else
        hResult[@sObjectID] = alias_str(@sObjectID, sTestID)
      end

      # �ѿ�̾
      unless (@hState[TSR_PRM_VAR].nil?())
        @hState[TSR_PRM_VAR].each_key{|sVarName|
          hResult[sVarName] = alias_str(sVarName, sTestID)
        }
      end

      return hResult  # [Hash]�����ꥢ���Ѵ��ơ��֥�
    end

    #=================================================================
    # ������: ���֥������Ȥ�ʣ�������֤�
    #=================================================================
    def dup()
      cObjectInfo = super()

      # ���֥�������IDʣ��
      cObjectInfo.sObjectID = safe_dup(@sObjectID)
      # ���֥������ȥ�����ʣ��
      cObjectInfo.sObjectType = safe_dup(@sObjectType)
      # �ѥ�᡼��ʣ��
      cObjectInfo.hState = safe_dup(@hState)

      return cObjectInfo  # [Object]ʣ���������֥�������
    end

    #=================================================================
    # ��  ��: ���֥������Ȥ����Ƥ�YAML���֥������Ȥ��Ѵ������֤�
    #=================================================================
    def to_yaml(bIsPre = false)
      check_class(Bool, bIsPre)  # pre_condition��

      hYaml = {}
      # pre�ξ��type°������Ϳ
      if (bIsPre == true)
        hYaml[TSR_PRM_TYPE] = @sObjectType
      end
      # �ݻ����Ƥ������������
      @hState.each{|sAtr, val|
        sRealAtr = get_real_attribute_name(sAtr)
        if (!val.nil?() || is_specified?(sRealAtr))
          case sAtr
          # �ѿ�
          when TSR_PRM_VAR
            hYaml[TSR_PRM_VAR] = {}
            val.each{|sVarName, cVar|
              hYaml[TSR_PRM_VAR][sVarName] = cVar.to_yaml()
            }
          # ����
          when TSR_PRM_STATE
            hYaml[sRealAtr] = get_real_state_value()
          # ����¾
          else
            hYaml[sRealAtr] = safe_dup(val)
          end
        end
      }

      return hYaml  # [Hash]YAML���֥�������
    end

    #=================================================================
    # ��  ��: ���֥����������¸�ߤ����ѿ�̾�������֤�
    #=================================================================
    def get_variable_names()
      aResult = []
      unless (@hState[TSR_PRM_VAR].nil?())
        aResult = @hState[TSR_PRM_VAR].keys()
      end

      return aResult  # [Array]���֥����������¸�ߤ����ѿ�̾����
    end

    #=================================================================
    # ��  ��: �����ݻ���°��̾����TESRY��°��̾���������
    #=================================================================
    def get_real_attribute_name(sAtr)
      check_class(String, sAtr)  # �����ݻ���°��̾

      case sAtr
      when TSR_PRM_STATE
        sAtr = GRP_PRM_KEY_PROC_STAT[@sObjectType]
      when TSR_PRM_ATR
        sAtr = GRP_PRM_KEY_PROC_ATR[@sObjectType]
      when TSR_PRM_LEFTTMO
        if (@sObjectType != TSR_OBJ_TASK)
          sAtr = TSR_PRM_LEFTTIM
        end
      end

      return sAtr  # [String]TESRY��°��̾
    end

    #=================================================================
    # ��  ��: �����ݻ��Ѿ���°������TESRY�ξ���°�����������
    #=================================================================
    def get_real_state_value()
      if (@bConvertState == true)
        hTempHash = GRP_OBJECT_STATE.invert()
        val = hTempHash[@hState[TSR_PRM_STATE]]
      else
        val = @hState[TSR_PRM_STATE]
      end

      return val  # [String]TESRY��°����
    end

    #=================================================================
    # ��  ��: YAML���ؤΥѥ������ꤹ��
    #=================================================================
    def set_path(aPath)
      check_class(Array, aPath)  # �롼�Ȥ���Υѥ�

      super(aPath)
      if (@hState[TSR_PRM_VAR].is_a?(Hash))
        @hState[TSR_PRM_VAR].each{|sVarName, cVar|
          cVar.aPath = aPath + [sVarName]
        }
      end
    end

    #=================================================================
    # ��  ��: Yaml�˵��Ҥ���Ƥ���ѥ�᡼���ꥹ�Ȥ�Ͽ����
    #=================================================================
    def set_specified_attribute(hObjectInfo)
      check_class(Hash, hObjectInfo)  # ���֥������Ⱦ���

      super(hObjectInfo)

      # ���������λ�롼�����do����
      if (hObjectInfo[TSR_PRM_DO].is_a?(Hash))
        @aSpecifiedDoAttributes = hObjectInfo[TSR_PRM_DO].keys()
      end
    end

    #=================================================================
    # ��  ��: value����������ѿ������뤫���֤�
    #=================================================================
    def is_value_set_variable?()
      bResult = false

      if (is_specified?(TSR_PRM_VAR))
        @hState[TSR_PRM_VAR].each_value{|cVar|
          if (cVar.is_value_set?())
            bResult = true
            break
          end
        }
      end

      return bResult  # [Bool]value����������ѿ������뤫
    end

    #=================================================================
    # ��  ��: activate�ʽ���ñ�̤����֤�
    #=================================================================
    def is_activate?()
      case @sObjectType
      when TSR_OBJ_TASK
        bResult = GRP_ACTIVATE.include?(@hState[TSR_PRM_STATE])
      when TSR_OBJ_INIRTN, TSR_OBJ_TERRTN
        bResult = false
      else
        bResult = GRP_ACTIVATE.include?(@hState[TSR_PRM_HDLSTAT])
      end

      return bResult  # [Bool]activate�ʽ���ñ�̤�
    end

    #=================================================================
    # ��  ��: ���ԥ��å��Ԥ��ν���ñ�̤�
    #=================================================================
    def is_spinlock_waiting?()
      case @sObjectType
      when TSR_OBJ_TASK
        bResult = (@hState[TSR_PRM_STATE] == TSR_STT_R_WAITSPN)
      when TSR_OBJ_INIRTN, TSR_OBJ_TERRTN
        bResult = false
      else
        bResult = (@hState[TSR_PRM_HDLSTAT] == TSR_STT_A_WAITSPN)
      end

      return bResult  # [Bool]���ԥ��å��Ԥ��ν���ñ�̤�
    end

    #=================================================================
    # ��  ��: lefttmo��lefttim�����ꤵ��Ƥ��뤫
    #=================================================================
    def has_lefttmo?()
      return !(@hState[TSR_PRM_LEFTTMO].nil?())  # [Bool]lefttmo��lefttim�����ꤵ��Ƥ��뤫
    end

    #=================================================================
    # ��  ��: ����ߥϥ�ɥ�ȳ���ߥ����ӥ��롼����ξ��֤�������֤�
    #=================================================================
    def is_initial_status?()
      return ((@hState[TSR_PRM_ATR] == KER_TA_NULL && @hState[TSR_PRM_STATE] == KER_TA_DISINT) ||
              (@hState[TSR_PRM_ATR] == KER_TA_ENAINT && @hState[TSR_PRM_STATE] == KER_TA_ENAINT))
             # [Bool]����ߥϥ�ɥ�ȳ���ߥ����ӥ��롼����ξ��֤�������֤�
    end
  end
end
