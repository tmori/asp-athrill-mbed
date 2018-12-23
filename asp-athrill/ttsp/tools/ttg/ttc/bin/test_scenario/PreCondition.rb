#!ruby -Ke
#
#  TTG
#      TOPPERS Test Generator
#
#  Copyright (C) 2009-2012 by Center for Embedded Computing Systems
#              Graduate School of Information Science, Nagoya Univ., JAPAN
#  Copyright (C) 2010-2011 by Graduate School of Information Science,
#                             Aichi Prefectural Univ., JAPAN
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
#  $Id: PreCondition.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: PreCondition
  # ��    ��: pre_condition�ξ����������륯�饹
  #===================================================================
  class PreCondition < Condition
    #=================================================================
    # ������: pre_condition�ι�¤�����å�
    #=================================================================
    def basic_check(hScenarioPre)
      check_class(Hash, hScenarioPre)  # pre_condition

      aErrors = []
      aPath = get_condition_path()
      # ���֥������Ȥι�¤�����å�
      hScenarioPre.each{|sObjectID, hObjectInfo|
        begin
          common_basic_check(sObjectID, hObjectInfo, aPath)

          # ���֥������Ȥι�¤�����꤬�ʤ���Х�����°���Υ����å�
          ### T1_018: pre_condition��Υ��֥������Ȥ�type°�����������Ƥ��ʤ�
          unless (hObjectInfo.has_key?(TSR_PRM_TYPE))
            sErr = sprintf("T1_018: " + ERR_REQUIRED_KEY, TSR_PRM_TYPE)
            aErrors.push(YamlError.new(sErr, aPath + [sObjectID]))
          else
            # ����Ǥ��륪�֥������ȥ�����
            if (@cConf.is_asp?())
              aObjectType = GRP_DEF_OBJECT_ASP.keys()
            elsif (@cConf.is_fmp?())
              aObjectType = GRP_DEF_OBJECT_FMP.keys()
            else
              abort(ERR_MSG % [__FILE__, __LINE__])
            end
            ### T1_017: ���ꤵ�줿���֥������ȥ����פ��������Ƥ��ʤ�
            unless (aObjectType.include?(hObjectInfo[TSR_PRM_TYPE]))
              sErr = sprintf("T1_017: " + ERR_OBJECT_UNDEFINED, hObjectInfo[TSR_PRM_TYPE])
              aErrors.push(YamlError.new(sErr, aPath + [sObjectID]))
            end
          end
        rescue TTCMultiError
          aErrors.concat($!.aErrors)
        end
      }

      check_error(aErrors)
    end

    #=================================================================
    # ��  ��: ����ǥ����������å�
    #=================================================================
    def condition_check()
      aErrors = []
      aPath = get_condition_path()

      begin
        super()
      rescue TTCMultiError
        aErrors.concat($!.aErrors)
      end

      # CPU_STATE�ν���
      aCpuLock = []
      hObjects = get_objects_by_type(TSR_OBJ_CPU_STATE)
      hObjects.each_value{|cObjectInfo|
        nPrcid = cObjectInfo.get_process_id()
        aCpuLock[nPrcid] = cObjectInfo
      }


      # ����ñ�̤Υ����å�
      hExistFlags = {:bProcessUnit => false, :bTask => false}
      hPOrder     = Hash.new{|hash, key|
        hash[key] = {:cRunning => nil, :aOthers => []}
      }
      hObjects = get_objects_by_type(GRP_PROCESS_UNIT_ALL)
      hObjects.each{|sObjectID, cObjectInfo|
        # ������
        if (cObjectInfo.sObjectType == TSR_OBJ_TASK)
          # ¸�ߥե饰true
          hExistFlags[:bTask] = true
          # ͥ���ٵ�ž�����å��Τ���Υǡ�������
          nPrcid = cObjectInfo.get_process_id()
          if (cObjectInfo.is_activate?())
            hPOrder[nPrcid][:cRunning] = cObjectInfo
          else
            hPOrder[nPrcid][:aOthers].push(cObjectInfo) 
          end
        end
        # �¹���ν���ñ�̤�¸��
        if (cObjectInfo.is_activate?())
          # ¸�ߥե饰true
          hExistFlags[:bProcessUnit] = true
        end
      }
      ### T4_001: pre_condition�Ǽ¹Ծ��֤ν���ñ�̤�¸�ߤ��ʤ�
      if (hExistFlags[:bProcessUnit] == false)
        aErrors.push(YamlError.new("T4_001: " + ERR_NO_RUNNING_PROCESS_UNIT, aPath))
      end
      ### T4_002: pre_condition�ǥ�������¸�ߤ��ʤ�
      if (hExistFlags[:bTask] == false)
        aErrors.push(YamlError.new("T4_002: " + ERR_NO_TASK, aPath))
      end

      # ͥ���ٵ�ž�Υ����å�
      hPOrder.each{|nPrcid, hTasks|
        unless (hTasks[:cRunning].nil?())
          hTasks[:aOthers].each{|cObjectInfo|
            ### T4_003: pre_condition��CPU��å����֤λ��ˡ���������ͥ���٤��Ф��Ƽ¹Ծ��֤���ž���Ƥ�����֤ˤʤäƤ���
            if (!aCpuLock[nPrcid].nil?() && aCpuLock[nPrcid].is_cpu_lock?() &&
                !cObjectInfo.hState[TSR_PRM_TSKPRI].nil?() && cObjectInfo.is_ready?() &&
                hTasks[:cRunning].hState[TSR_PRM_TSKPRI] > cObjectInfo.hState[TSR_PRM_TSKPRI])
              sErr = sprintf("T4_003: " + ERR_INVERTED_STATE_IN_PRE, nPrcid)
              aErrors.push(YamlError.new(sErr, aPath))
              break
            end
            ### T4_004: pre_condition��porder����ž���Ƥ�����֤ˤʤäƤ���
            if (hTasks[:cRunning].hState[TSR_PRM_TSKPRI] == cObjectInfo.hState[TSR_PRM_TSKPRI] &&
                !hTasks[:cRunning].hState[TSR_PRM_PORDER].nil?() && !cObjectInfo.hState[TSR_PRM_PORDER].nil?() &&
                hTasks[:cRunning].hState[TSR_PRM_PORDER] > cObjectInfo.hState[TSR_PRM_PORDER])
              sErr = sprintf("T4_004: " + ERR_INVERTED_PORDER_IN_PRE, nPrcid)
              aErrors.push(YamlError.new(sErr, aPath))
              break
            end
          }
        end
      }


      # �������㳰
      hObjects = get_objects_by_type(TSR_OBJ_TASK_EXC)
      hObjects.each{|sObjectID, cObjectInfo|
        # ��Ϣ������
        sTask = cObjectInfo.hState[TSR_PRM_TASK]
        if (@hAllObject.has_key?(sTask))
          cTask = @hAllObject[sTask]
          if (cTask.sObjectType == TSR_OBJ_TASK)
            ### T4_034: �������㳰�����롼����ε�ư�����������Ƥ���Τ�ACTIVATE�Ǥʤ�
            if (cTask.is_activate?() && cObjectInfo.hState[TSR_PRM_STATE] == TSR_STT_TTEX_ENA &&
                cObjectInfo.hState[TSR_PRM_HDLSTAT] == TSR_STT_STP && cObjectInfo.hState[TSR_PRM_PNDPTN] != 0)
              aErrors.push(YamlError.new("T4_034: " + ERR_NOT_ACTIVATE_TASK_EXC, aPath + [sObjectID]))
            end
          ### T4_022: ��Ϣ������ID�Υ��֥������Ȥ��������Ǥʤ�
          else
            sErr = sprintf("T4_022: " + ERR_TARGET_NOT_TASK, sTask)
            aErrors.push(YamlError.new(sErr, aPath + [sObjectID, TSR_PRM_TASK]))
          end
        ### T4_021: ��Ϣ������ID�Υ��֥������Ȥ�¸�ߤ��ʤ�
        else
          sErr = sprintf("T4_021: " + ERR_TARGET_NOT_DEFINED, sTask)
          aErrors.push(YamlError.new(sErr, aPath + [sObjectID, TSR_PRM_TASK]))
        end
      }

      check_error(aErrors)
    end

    #=================================================================
    # ������: ����ͤ��䴰����
    #=================================================================
    def complement_init_object_info()
      @hAllObject.each_value{|cObjectInfo|
        cObjectInfo.complement_init_object_info()
      }
    end

    #=================================================================
    # ������: �����֥������ȡ��ѿ��Υ����ꥢ���Ѵ��ơ��֥���֤�
    #=================================================================
    def get_alias()
      hResult       = {}
      hSpinCount    = Hash.new(1)  # ���ԥ��å���̾������Τ��᥯�饹���о����򥫥����
      aSortedObject = @hAllObject.sort()
      aSortedObject.each{|aObjectInfo|
        cObjectInfo = aObjectInfo[1]
        if (cObjectInfo.sObjectType == TSR_OBJ_SPINLOCK)
          sClass = cObjectInfo.hState[TSR_PRM_CLASS]
          hAlias = cObjectInfo.get_alias(@sTestID, hSpinCount[sClass])
          hSpinCount[sClass] += 1
        else
          hAlias = cObjectInfo.get_alias(@sTestID)
        end
        hResult = hResult.merge(hAlias)
      }

      return hResult  # [Hash]�����ꥢ���Ѵ��ơ��֥�
    end

    #=================================================================
    # ��  ��: ����������������������֤�
    #=================================================================
    def is_time_control_situation?(hVariation)
      check_class(Hash, hVariation)  # �Хꥨ����������

      bResult = super(hVariation)

      if (bResult == false)
        hObjects = get_objects_by_type(GRP_TIME_EVENT_HDL)
        hObjects.each_value{|cObjectInfo|
          # pre_condition��ACTIVATE�ʥ����।�٥�ȥϥ�ɥ餬¸�ߤ���
          if (cObjectInfo.is_activate?())
            bResult = true
            break
          # pre_condition�ˤ����ơ�cycstat��TCYC_STA�����ꤵ��Ƥ�������ϥ�ɥ餬¸�ߤ���
          elsif (cObjectInfo.sObjectType == TSR_OBJ_CYCLE && cObjectInfo.is_cyc_sta?())
            bResult = true
            break
          end
        }
      end

      return bResult  # [Bool]�������������������
    end

    #=================================================================
    # ������: pre_condition�Υѥ�������֤�
    #=================================================================
    def get_condition_path()
      return [@sTestID, TSR_LBL_PRE]  # [Array]pre_condition�Υѥ�����
    end

=begin
    #=================================================================
    # ������: ������ֹ�������������
    #=================================================================
    def get_all_intno()
      aResult  = []
      hObjects = get_objects_by_type([TSR_OBJ_INTHDR, TSR_OBJ_ISR])
      hObjects.each_value{|cObjectInfo|
        aResult.push(cObjectInfo.hState[TSR_PRM_INTNO])
      }

      return aResult.uniq()  # [Array]������ֹ����
    end
=end
  end
end
